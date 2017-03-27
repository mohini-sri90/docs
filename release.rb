#!/usr/bin/ruby -w

# Tool to make a new release of RTS docs
#
# Usage: ruby release.rb [-v|--version string]
#
# The version string must be in the form X.Y.Z where the X, Y and Z are numbers
#

%w{fileutils find optparse ostruct tempfile}.each{ |f| require f }

# a single Java file can contain multiple top level classes, so we keep track of each
# such class, whether a Javadoc exists for it, and if so where the comment begins and
# ends and whether it contains an @since tag.
#
class Release
  # for debugging
  DBG = true

  # remote we want to push to
  ORIGIN = 'git@github.com:datatorrent/docs'

  # directory where release will be created
  DEST_DIR = '/tmp/rts-docs'

  # prefixes of release branch and tag names
  # NOTE: The branch prefix should be changed with care since it is also used to name the
  # release directory
  #
  PREFIX_BRANCH = 'release-'
  PREFIX_TAG = 'version-'

  # branch whose content is finally published
  PUB_BRANCH = 'gh-pages'

  # name of directory in 'gh-pages' branch holding version before introduction of formal
  # versioning
  #
  FIRST_RELEASE = 'prior-release'

  # name of markdown file containing links to prior releases
  PRIOR_RELEASES = 'prior_releases.md'

  # name of file that has all the navigation links in the left panel
  YAML_FILE = 'mkdocs.yml'

  # regex for version string
  R_VERSION = /\A(\d+)\.(\d+)\.(\d+)\Z/oi

  # regular expression for directory names in gh-pages branch containing old releases
  R_OLD_RELEASE_DIR = %r{release-.+}o

  # Regular expression to match lines like this:
  #
  # - [3.7.1](http://docs.datatorrent.com/release-3.7.1/index.html)
  # - [Previous release](http://docs.datatorrent.com/prior-release/index.html)
  #
  R_RELEASE_LINK = %r{ - \[([^\]\[]+)\]\(([^)(]+)\)}io

  # pattern for untracked files
  R_UNTRACKED = /\?\? /o

  # Commandline options parsed and stored here.
  #
  # version -- new version to release
  #
  OPT = OpenStruct.new( :version => nil )

  # version -- version string of new release
  # major, minor, patch -- parsed components of version string
  # dir -- temporary destination directory for release
  # origin -- name of remote we want to push to
  #
  attr :version, :major, :minor, :patch, :dir, :origin

  def initialize
    v = OPT.version
    raise 'Error: Bad version "%s"' % v if v !~ R_VERSION
    @major, @minor, @patch = $1, $2, $3
    @version = v
    @dir = OPT.dir ? OPT.dir : DEST_DIR

    # find the remote to push to
    list = run("git remote -v", "Error: git remote -v failed")
    list.each_line{ |line|
      fields = line.split
      next if fields[1] != ORIGIN
      @origin = fields[0]
      break
    }
    raise "Error: Failed to find remote #ORIGIN" if ! defined? @origin
    puts 'major = %s, minor = %s, patch = %s, dir = %s, origin = %s' %
         [@major, @minor, @patch, @dir, @origin]
  end

  # parse commandline args
  def self.parse_args
    opt = OptionParser.new
    opt.banner = "Usage: ruby -w release.rb [options]"

    opt.separator ''
    opt.separator 'Specific options:'

    opt.on( '-v', '--version string', 'Target version X.Y.Z' ) { |v| OPT.version = v.strip }
    opt.on( '-u', '--update', 'Update old version' ) {
      raise 'Error: Duplicate -u option' if :update == OPT.type
      raise 'Error: Use only one of -u and -n options' if :new == OPT.type
      OPT.type = :update
    }
    opt.on( '-n', '--new', 'Publish new version [default]' ) {
      raise 'Error: Duplicate -n option' if :new == OPT.type
      raise 'Error: Use only one of -u and -n options' if :update == OPT.type
      OPT.type = :new
    }

    opt.separator ''
    opt.separator 'Common options:'

    opt.on_tail('-h', '--help', "Show this message") {
      puts opt
      exit
    }
    
    # strips all parsed arguments from ARGV
    opt.parse! ARGV

    OPT.freeze

  end  # parse_args

  # run an external shell command and return only success/failure status
  def run? cmd
    %x{#{cmd}}
    # puts 'cmd = %s, result = %s\n' % [cmd, result]
    return $?.success?
  end  # run?

  # run an external shell command; if successful, the output is returned else an exception
  # with the given message is raised
  #
  def run(cmd, msg)
    result = %x{#{cmd}}
    return result if $?.success?
    raise msg
  end  # run

  # return list of untracked files if any, nil otherwise
  def untracked
    result = run('git status --porcelain', 'Error: git status failed')
    return nil if result !~ R_UNTRACKED
    return result.split(/\n/).select { |x| x =~ R_UNTRACKED }
  end  # untracked

  # sanity checks for either new release or update
  def check
    # there should be no uncommitted changes
    raise 'Error: There are uncommitted changes' if ! run? 'git diff-index --quiet HEAD --'
    list = untracked
    raise 'Error: Untracked files present: %s' % list if list
  end  # check

  # check that YAML_FILE contains a link to PRIOR_RELEASES
  def check_yaml
    IO.foreach(YAML_FILE) { |line|
      return if line.index PRIOR_RELEASES
    }
    raise 'Error: %s does not have a link to %s' % [YAML_FILE, PRIOR_RELEASES]
  end  # check_yaml

  # parse PRIOR_RELEASES file under 'docs'; return true if there is a line for @version
  # false otherwise
  #
  def release_exist?
    path = File.join('docs', PRIOR_RELEASES)
    raise 'Error: %s not found' % path if ! File.exist? path
    raise 'Error: %s not readable' % path if ! File.readable? path
    raise 'Error: %s not a plain file' % path if ! File.file? path

    IO.foreach(path) { |line|
      next if line !~ R_RELEASE_LINK

      # the first entry should be the latest
      @latest = $1 if ! defined? @latest

      return true if $1 == @version
    }
    return false
  end  # release_exist?

  # check that we are on the named branch and return list of local branches
  def get_branches name
    # get list of branches; current branch has a '*' in front
    s = run('git branch', 'Error: git branch failed')
    branches = s.split
    p1 = branches.index '*'
    p2 = branches.index name
    raise 'Error: failed to find current branch' if ! p1
    raise 'Error: failed to find branch "%s"' % name if ! p2
    raise 'Error: must be on branch "%s", not "%s"' % [name, branches[p1 + 1]] if
      p2 != 1 + p1
    return branches
  end  # get_branches

  # sanity checks before making a new release
  def checks_for_new_release
    branches = get_branches 'master'

    # check if new release branch already exists
    @branch_name = PREFIX_BRANCH + @version
    raise 'Error: branch %s already exists' % @branch_name if branches.index @branch_name

    # check if new tag already exists
    raise 'Error: failed to fetch tags' if ! run? 'git fetch --tags'
    tags = run('git tag', 'Error: failed to get tags').split
    @new_tag = PREFIX_TAG + @version
    raise 'Error: tag %s already exists' % new_tag if tags.index @new_tag

    # check that there is a navigation link to PRIOR_RELEASES in mkdocs.yml
    check_yaml

    # parse PRIOR_RELEASES file to ensure new release is not already present
    raise 'Error: Link for %s already present in %s' % [@version, PRIOR_RELEASES] if
      release_exist?

    puts '@branch_name = %s, @new_tag = %s' % [@branch_name, @new_tag]
  end  # checks_for_new_release

  # sanity checks before updating an old release
  def checks_for_update
    # first release (i.e. before versioning was implemented) cannot be updated
    raise 'Error: first release "%s" cannot be updated' % @version if @version == FIRST_RELEASE

    # check that we are on the release branch
    @branch_name = PREFIX_BRANCH + @version
    get_branches @branch_name

    # parse PRIOR_RELEASES file to ensure that release is present
    raise 'Error: Link for %s absent in %s' % [@version, PRIOR_RELEASES] if
      ! release_exist?

  end  # checks_for_update

  # remove all files and directories in gh-pages branch except the subdirectories
  # for previous releases
  #
  def remove_prev_release
    puts 'START -- Remove previous release files' if DBG
    skip = %w{. .. .git .gitignore}        # ignore these files/directories

    # all this is happening in the current directory, so no need for path prefix
    Dir.foreach('.') { |entry|
      next if skip.include? entry

      # skip if entry is not tracked by git
      next if run('git log -1 -- #{entry}', 'Error: git log failed for #{entry}').empty?

      if File.file? entry
        puts "Removing file: %s" % entry if DBG
        FileUtils.rm entry
        next
      end
      raise 'Error: %s is neither a plain file nor a directory' if ! File.directory? entry

      # preserve prior release directories named 'release-*' or 'prior-release'
      next if entry =~ R_OLD_RELEASE_DIR || entry == FIRST_RELEASE

      puts "Removing dir: %s" % entry if DBG
      FileUtils.rm_r entry
    }
    puts 'FINISH -- Remove previous release files' if DBG
  end  # remove_prev_release

  def update_latest_release dest
    puts 'START -- Copy new site files' if DBG
    Dir.foreach(dest) { |file|
      next if '.' == file || '..' == file        # skip . and ..
      path = File.join(dest, file)
      if File.file? path
        puts "Copying file: %s" % file if DBG
        FileUtils.cp path, '.'
        next
      end
      raise 'Error: %s is neither a plain file nor a directory' if ! File.directory? path

      puts "Copying dir: %s" % file if DBG
      FileUtils.cp_r path, '.'
    }
    puts 'FINISH -- Copy new site files' if DBG
  end  # update_latest_release

  # add link to new release into PRIOR_RELEASES
  def add_link
    path = File.join('docs', PRIOR_RELEASES)
    new_file = Tempfile.new PRIOR_RELEASES
    begin
      File.foreach(path) { |line|
        new_file << line
        next if $. != 2
        new_file.puts '- [%s](http://docs.datatorrent.com/%s/index.html)' % [@version, @branch_name]
      }
    ensure
      # close temp file, remove old file, move new file to old location, delete temp file
      new_file.close
      puts 'Removing %s' % path if DBG
      FileUtils.rm path
      puts 'Renaming %s as %s' % [new_file.path, path] if DBG
      FileUtils.mv new_file.path, path
      puts 'Unlinking %s' % new_file.path if DBG
      new_file.unlink
    end
  end  # add_link

  def create_release
    # add link for new release to PRIOR_RELEASES and commit
    add_link
    run "git commit -am 'Add link for version #@version'", "Error: failed to commit to master"
    puts 'Committed change to master' if DBG

    # create new branch
    run "git branch #@branch_name", "Error: failed to create branch #@branch_name"
    puts 'Created new branch "%s"' % @branch_name if DBG

    # create new tag
    run "git tag -a #@new_tag -m 'Release #@version'", "Error: failed to create tag #@new_tag"
    puts 'Created new tag "%s"' % @new_tag if DBG

    # build site files
    dest = File.join(@dir, @branch_name)
    run "mkdocs build -d #{dest}", "Error: failed to build site at #{dest}"
    puts 'Created new site at "%s"' % dest if DBG

    # checkout publishing branch
    run "git checkout #{PUB_BRANCH}", "Error: failed to checkout #{PUB_BRANCH}"
    puts 'Checked out branch "%s"' % PUB_BRANCH if DBG

    # remove all files and directories except the directories for previous releases
    remove_prev_release

    # copy content of new release here
    update_latest_release dest

    # move the newly created site directory here
    FileUtils.mv dest, '.'
    puts 'Moved "%s" to .' % dest if DBG

    # check if any new files need to be added to PUB_BRANCH
    list = untracked
    if list
      puts 'list.size = %d, running "git add ."' % list.size if DBG
      run('git add .', 'Error: git add failed') if list
    else
      puts 'list is nil' if DBG
    end

    # commit the new release to PUB_BRANCH
    puts 'Running git commit' if DBG
    run "git commit -am 'Add release #@version'", 'Error: git commit -am failed'

    # push:
    #   PUB_BRANCH (to publish new release)
    #   master (for the change to docs/prior_releases.md)
    #   new release branch release-X.Y.Z
    #   new release tag: version-X.Y.Z
    #
    puts 'Running git push' if DBG
    run "git push #@origin #{PUB_BRANCH} master #@branch_name #@new_tag",
        "Error: git push failed for #{PUB_BRANCH}" if false
    puts 'You are now on the "%s" branch' % PUB_BRANCH
  end  # create_release

  # update an existing release
  def update_release
    check
    checks_for_update

    # build site files
    dest = File.join(@dir, @branch_name)
    run "mkdocs build -d #{dest}", "Error: failed to build site at #{dest}"

    # checkout publishing branch
    run "git checkout #{PUB_BRANCH}", "Error: failed to checkout #{PUB_BRANCH}"

    # check that the release directory is present
    raise 'Error: directory "%s" not found in branch #{PUB_BRANCH}' if
      ! File.directory? @branch_name

    # if release is the latest, remove all old files and replace with new files
    if @latest == @version
      # remove all files and directories except the directories for previous releases
      remove_prev_release

      # copy newly created content here
      update_latest_release dest
    end

    # remove existing release directory
    FileUtils.rm_r @branch_name

    # move the newly created site directory here
    FileUtils.mv dest, '.'
    puts 'Moved "%s" to .' % dest if DBG

    # check if any new files need to be added to PUB_BRANCH
    list = untracked
    if list
      puts 'list.size = %d, running "git add ."' % list.size if DBG
      run('git add .', 'Error: git add failed') if list
    else
      puts 'list is nil' if DBG
    end

    # commit the new release to PUB_BRANCH
    puts 'Running git commit' if DBG
    run "git commit -am 'Add release #@version'", 'Error: git commit -am failed'

    # push:
    #   PUB_BRANCH (to publish new release)
    #   master (for the change to docs/prior_releases.md)
    #   new release branch release-X.Y.Z
    #   new release tag: version-X.Y.Z
    #
    puts 'Running git push' if DBG
    run "git push #@origin #{PUB_BRANCH} master #@branch_name #@new_tag",
        "Error: git push failed for #{PUB_BRANCH}" if false
    puts 'You are now on the "%s" branch' % PUB_BRANCH

  end  # update_release

  # create a new release
  def make_release
    check
    checks_for_new_release
    create_release
  end  # make_release

  # main entry point
  def self.go
    parse_args
    raise "Error: need release version" if ! OPT.version
    rel = Release.new
    OPT.type == :update ? rel.update_release : rel.make_release
  end  # go

end  # Release

Release.go
