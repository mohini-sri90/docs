# DataTorrent Documentation

DataTorrent documentation repository for content available on http://docs.datatorrent.com/

Documentation is written in [Markdown](https://guides.github.com/features/mastering-markdown/) format and statically generated into HTML using [MkDocs](http://www.mkdocs.org/).  All documentation is located in the [docs](docs) directory, and [mkdocs.yml](mkdocs.yml) file describes the navigation structure of the published documentation.

## Authoring

Start by installing mkdocs using Python package manager, pip.  For additional installation questions see http://www.mkdocs.org/

```bash
pip install mkdocs
```

New pages can be added under [docs](docs) or related sub-category, and a reference to the new page must be added to the [mkdocs.yml](mkdocs.yml) file to make it available in the navigation.  Embedded images are typically added to images folder at the same level as the new page.

When creating or editing pages, it can be useful to see the live results, and how the documents will appear when published.  Live preview feature is available by running the following command at the root of the repository:

```bash
mkdocs serve
```

For additional details see [writing your docs](http://www.mkdocs.org/user-guide/writing-your-docs/) guide.

## Site Configuration

Guides on applying site-wide [configuration](http://www.mkdocs.org/user-guide/configuration/) and [themeing](http://www.mkdocs.org/user-guide/styling-your-docs/) are available on the MkDocs site.

## Hosting

Currently docs.datatorrent.com is hosted on Github Pages.  The deployment requires that a custom [CNAME](docs/CNAME) be present at docs level, and DNS entry for docs.datatorrent.com point to datatorrent.github.io.

## Deployment and Versioning

**NOTE** Please make sure to use mkdocs v0.16.0 or later by running `mkdocs --version`.  If you have an older version of mkdocs installed upgrade with:

```bash
sudo pip install --upgrade mkdocs
```

Please note that we no longer use `mkdocs gh-deploy --clean` -- that command should
_NOT_ be used. Instead, deployment is done using the `release.rb` Ruby script.
You can get a usage message with:

```
ruby -w release.rb -h
```

If making a new release, say X.Y.Z, make sure that:
- You are on the `master` branch and all necessary changes are present in that branch.
- There are no uncommitted changes.
- There are no untracked files.

Then, run the following command:
```
ruby -w release.rb -v X.Y.Z
```

It executes the following steps:
- perform a variety of checks
- add a link to the new release in `docs/prior_releases.md`
- create a new branch `release-X.Y.Z` and a new tag `version-X.Y.Z`
- build the site at `/tmp/rts-docs`
- copy new site files into the `gh-pages` branch
- push all 3 branches and the tag

If updating an old release, say U.V.W, make sure that:
- You are on the `release-U.V.W` branch and all necessary changes are present in that branch.
- There are no uncommitted changes
- There are no untracked files

Then, run the following command:
```
ruby -w release.rb -v U.V.W -u
```

It executes the following steps:
- perform a variety of checks
- build the site at `/tmp/rts-docs`
- copy new site files into the `gh-pages` branch under the release directory
- push that branch



