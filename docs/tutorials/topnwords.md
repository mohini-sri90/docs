Top N Words Application
=======================

The Top N words application is a tutorial on building a word counting application using:

-   Apache Apex platform
-   Apache Apex Malhar, an associated library of operators
-   Other related tools

Note: Before you begin, ensure that you have internet connectivity
because, in order to complete this tutorial, you will need to download
the Apex and Malhar code.

The Top N Words application monitors an input directory for new
files. When the application detects a new file, it reads its lines,
splits them into words and computes word frequencies for both that specific file
as well as across all files processed so far. The top N words (by
frequency) and their frequencies are output to a corresponding file in
an output directory. Simultaneously, the word-frequency pairs are also
updated on **dtDashboard**, the browser-based dashboard of DataTorrent RTS.

A simple word counting exercise was chosen because the goal of this tutorial is to focus on the use of:

-   The Apex platform
-   The operator library
-   The tools required for developing and deploying
    applications on a cluster
-   **apex** &ndash; the command-line tool for managing
    application packages and the constituent applications
-   **dtManage** &ndash; for monitoring the applications
-   **dtDashboard** &ndash; for visualizing the output
-   **dtAssemble** &ndash; for  visual application assembly

In the context of such an application, a number of questions arise:

-   What operators do we need ?
-   How many are present in the Malhar library ?
-   How many need to be written from scratch ?
-   How are operators wired together ?
-   How do we monitor the running application ?
-   How do we display the output data in an aesthetically pleasing way ?

The answers to these and other questions are explored in the sections below.

For this tutorial, use the DataTorrent RTS Sandbox; it comes pre-installed
with Apache Hadoop and the latest version of DataTorrent RTS configured as a single-node
cluster and includes a time-limited enterprise license. If you've already installed DataTorrent RTS, you
can use that setup instead.
