# Anchore Enterprise + VIPERR Workshop

This README file will include step by step instructions on using Anchore Enterprise to meet the VIPERR Guidelines. This means providing Visbility, Inspection, Policy Enforcement, Remediation, and Reporting across your software supply chain to create a more secure cloud native application. To begin, let's get your system configured and ready to rock!

### System Configruation for anchore-cli

The Anchore CLI provides a command line interface on top of the `Anchore Engine <https://github.com/anchore/anchore-engine>`_ REST API.

Using the Anchore CLI users can manage and inspect images, policies, subscriptions and registries for the following:

**Supported Operating Systems**

* Alpine
* Amazon Linux 2
* CentOS
* Debian
* Google Distroless
* Oracle Linux
* Red Hat Enterprise Linux
* Red Hat Universal Base Image (UBI)
* Ubuntu


**Supported Packages**

* GEM
* Java Archive (jar, war, ear)
* NPM
* Python (PIP)


Installing Anchore CLI from source
==================================

The Anchore CLI can be installed from source using the Python pip utility

.. code::

    git clone https://github.com/anchore/anchore-cli
    cd anchore-cli
    pip install --user --upgrade .

Or can be installed from the installed form source from the Python `PyPI <https://pypi.python.org/pypi>`_ package repository.

Installing Anchore CLI on CentOS and Red Hat Enterprise Linux
=============================================================

.. code::

    yum install epel-release
    yum install python-pip
    pip install anchorecli

Installing Anchore CLI on Debian and Ubuntu
===========================================

.. code::

    apt-get update
    apt-get install python-pip
    pip install anchorecli
    Note make sure ~/.local/bin is part of your PATH or just export it directly: export PATH="$HOME/.local/bin/:$PATH"

Installing Anchore CLI on Mac OS / OS X
===========================================

Use Python's `pip` package manager:

.. code::

    sudo easy_install pip
    pip install --user anchorecli
    export PATH=${PATH}:${HOME}/Library/Python/2.7/bin

To ensure `anchore-cli` is readily available in subsequent terminal sessions, remember to add that last line to your shell profile (`.bash_profile` or equivalent).

To update `anchore-cli` later:

.. code::

    pip install --user --upgrade anchorecli


Configuring the Anchore CLI
===========================

By default the Anchore CLI will try to connect to the Anchore Engine at ``http://localhost/v1`` with no authentication.
The username, password and URL for the server can be passed to the Anchore CLI as command line arguments.

.. code::

    --u   TEXT   Username     eg. admin
    --p   TEXT   Password     eg. foobar
    --url TEXT   Service URL  eg. http://localhost:8228/v1

Rather than passing these parameters for every call to the cli they can be stores as environment variables.

.. code::

    ANCHORE_CLI_URL=http://myserver.example.com:8228/v1
    ANCHORE_CLI_USER=admin
    ANCHORE_CLI_PASS=foobar

Command line examples
=====================

Add an image to the Anchore Engine

.. code::

    anchore-cli image add  docker.io/repo/image:tag

Wait for an image to transition to ``analyzed``

.. code::

    anchore-cli image wait docker.io/repo/image:tag

List images analyzed by the Anchore Engine

.. code::

    anchore-cli image list

Get summary information for a specified image

.. code::

    anchore-cli image get docker.io/repo/image:tag

Perform a vulnerability scan on an image

.. code::

   anchore-cli image vuln docker.io/repo/image:tag os

Perform a policy evaluation on an image

.. code::

   anchore-cli evaluate check docker.io/repo/image:tag --detail

List operating system packages present in an image

.. code::

    anchore-cli image content docker.io/repo/image:tag os

Subscribe to receive webhook notifications when new CVEs are added to an update

.. code::

    anchore-cli subscription activate vuln_update docker.io/repo/image:tag
    
 ## Accessing the Anchore Enterprise UI
 
 To access the Anchore UI for this workshop, please go to the following URL: 
 
 Once logged in you should see a Dashboard. To get started with enforcing the VIPERR Framework, let's start analyzing some of images.
 
 # Visibility
 
 In order to see visibility in action lets start by analyzing an image. There are two paths to do this
 
 1. Using the UI. Go to Image Analysis tab. On the right hand side of the screen select, "Analyze Tag", specifying the registry, repository, tag. For now, pick your favorite image off of dockerhub.

2. Using the CLI, perform the following `anchore-cli image add docker.io/ubuntu:latest`
3. After completing Step 1 or Step 2, navigate to the UI to validate your image was successfully added for analysis
4. Once the Image has analyzed, it is time to view the contents to gain Visibility inside of that image. Let's start by viewing the SBOM in the "Contents" tab.
5. Select your image from the image analysis tab. Once loaded, go to the "Contents Tab"
6. Click through the contents (OS, Files, Malware, Secrets, etc)
7. Take 5 minutes to explore and wait for instructor Guidance

Pro Tip: Retrieving contents can be done in your pipelines by creating something fun like `anchore-cli image content docker.io/repo/image:tag os > contents-os.json `

## Visibility Cheat Sheet
```
1.1  Identification of os + language packages : Contents Tab > OS + language tabs 
1.2 Identification of package licensing : Contents Tab
1.3 Identification of package origin : Contents Tab
1.4 Identification of package size : Contents Tab
1.5 Identification of all files : Contents Tab > Files
1.6 Identification of file size : Contents Tab > Files
1.7 Identification of file permissions : Contents Tab > Files
1.8 Identification of files unique identifiers Contents Tab > Files
1.9 Identification of relevant metadata: Metadata Tab
1.10 Delta SBOM analysis between builds : Changelog Tab
```
## Inspection

Now that you have cataloged an SBOM, Anchore has completed the vulnerability analysis against that SBOM. It's time to inspect that image to find out what in that image is damaging or potentially harmful to your org.

1) Go to the Vulnerabilities Tab
2) Explore
3) What is that "view report" button? Explore relationships between vulnerability data. 
4) Identify the CVE with Fixes that YOU can make. Filter on CVE's NOT inherited by base image.
5) Which CVE's are coming from your base image? 
6) Do you have malware in this image?  Inspect the Contents tab under malware to identify if your image is free of malware. Combine with 1.10 of Visibility to identify where malware was introduced. 
7) Do you have secrets detected in the image? Use the "Secret Search" tab within "Contents"
8) Any license abuse? Go to the Policy Enforcement tab to detect anything violating policy. Or, quickly query for that license in the Contents tab.
9) Check Build history to inspect misconfiguration in dockerfiles. You can also inspect dockerfile misconfiguration in policy enforcement tab

### Insepction Cheat Sheet

```
2.1 Inspect Files for malicious content
2.2 Inspect packages for malicious content
2.3 Inspect packages for known CVEs
2.4 Inspect for license abuse/misuse
2.5 Inspect for secret abuse/misuse
2.6 Inspect & Monitor file permissions 
2.7 Inspect for misconfiguration in the Dockerfiles
2.8 Inspect for vulns inherited by base images
2.9 Inspect for malware between each build
```
## Policy Enforcement

1) Go to Policy Bundles Tab to see sample policies
2) Pause. Wait for Guidance from Instructor
3) Try creating a sample policy that triggers a "Warning Action" on all CVE's greater than "High"
4) Create a sample policy that triggers a "Stop Action" on all images built with a root user
5) Create a trigger that warns on no healthcheck in the dockerfile
6) Create a custom check and be prepared to share with the group. 
7) Diagnose which policy failures are derived from your base image
8) Why would policy enforcement be important? 
9) Group discussion

### Policy Enforcement Cheat Sheet

```
3.1 Identify  & Enforce  your compliance baselines early
3.2 Create a policy that doesn’t cripple velocity
3.3 Enforce control of license abuse/misuse via Policy
3.4 Enforce Secret + Password  Monitoring in Policy
3.5 Only pull from authorized registries
3.6 Enforce building from approved images
3.7 Detect & Block misconfigurations in dockerfiles
3.8 Policy blocks unauthorized images reaching prod 
3.9 Don’t pass builds that violate CVE thresholds

```

## Remediation 

1) Your developers need to know what the hell they did wrong. Let's tell them.
2) Go to Policy Compliance Tab so you can see all of the compliance failures and rules that failed your analysis. It is good to use an image with a lot of failures for this.
3) Click on a failed Trigger and select "show remediation actions"
4) Select a remediation action
5) Select Add to workbench
6) Repeat
7) Typically, you would have a integration for the action plan.
8) Validate the action plan items are sent to the appropriate notification service

### Remediation Cheat Sheet
```
4.1 Provide remediations steps for bad Dockerfiles
4.2 Automate the flow of CVE fix information to developers
4.3 Provide ownership who owns the fix (upstream or us)
4.4 Integrate remediation to your notification & build service
4.5 Enforce building from approved images
```
## Reporting

1) Go To Reports Tab
2) Open up the templates tab and explore
3) Explore


### Reporting Cheat Sheet
```
5.1 Provide timely reports
5.2 Include reports that have accurate temporal data
5.3 Reports should have relational context
5.4 Reporting should be 100% automated
5.5 Reports should be accurate
5.6 Reports should reference impacted artifacts 
```








