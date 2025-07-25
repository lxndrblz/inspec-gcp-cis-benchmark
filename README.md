# GCP CIS 4.0.0 Benchmark Inspec Profile

This repository holds the Google Cloud Platform (GCP) Center for Internet Security (CIS) Version 4.0 Benchmark [Inspec](https://www.inspec.io/) Profile. It's a fork of the stale GoogleCloudPlatform [repository](https://github.com/GoogleCloudPlatform/inspec-gcp-cis-benchmark), which hasn't been maintained in several years and is no longer executable.

> [!WARNING]  
> This is not an officially supported Google product. This code is intended to help users assess their security posture on the Google Cloud against the CIS Benchmark. This code is not certified by CIS.

## ✅ Coverage

The profiles cover all controls of the current version. Due to missing APIs and/or required manual verfication, the following controls are currently not scored:

https://github.com/search?q=repo%3Alxndrblz%2Finspec-gcp-cis-benchmark+%22cis_scored%3A+false%22&type=code

## 🚀 Usage

### Profile Inputs (see `inspec.yml` file)

This profile uses InSpec Inputs to make the tests more flexible. You are able to provide inputs at runtime either via the `cli` or via `YAML files` to help the profile work best in your deployment.

**pro-tip**: Do not change the inputs in the `inspec.yml` file directly, either:

- update them via the cli - via the `--input` flag
- pass them in via a YAML file as shown in the `Example` - via the `--input-file` flag

Further details can be found here: <https://docs.chef.io/inspec/inputs/>

### (Required) User Provided Inputs - via the CLI or Input Files

- **gcp_project_id** - (Default: null, type: String) - The target GCP Project you are scanning.

### (Optional) User Provided Inputs

- **sa_key_older_than_seconds** - (Default: 7776000, type: int, CIS IAM 1.15) - The maximum allowed age of GCP User-managed Service Account Keys (90 days in seconds).
- **kms_rotation_period_seconds** - (Default: 7776000, type: int, CIS IAM 1.10) - The maximum allowed age of KMS keys (90 days in seconds).

### Cloud Shell Walkthrough

Use this Cloud Shell Walkthrough for a hands-on example.

[![Open this project in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/lxndrblz/inspec-gcp-cis-benchmark&page=editor&tutorial=walkthrough.md)

### CLI Example

#### 💎 Ruby Gem

```sh
# install the latest inspec version
$ gem install cinc-auditor-bin --clear-sources -s https://rubygems.cinc.sh -s https://rubygems.org
```

```sh
# make sure you're authenticated to GCP
$ gcloud auth list
```

```sh
# acquire credentials to use with Application Default Credentials
$ gcloud auth application-default login

```

```sh
# scan a project with this profile, replace {{project-id}} with your project ID
$ cinc-auditor exec https://github.com/GoogleCloudPlatform/inspec-gcp-cis-benchmark.git -t gcp:// --input gcp_project_id={{project-id}}  --reporter cli json:{{project-id}}_scan.json
...snip...
Profile Summary: 48 successful controls, 5 control failures, 7 controls skipped
Test Summary: 166 successful, 7 failures, 7 skipped
```

#### 🐳 Docker
```sh
# pull inspec image
$ docker pull cincproject/auditor:5.22.80
```

```sh
# make sure you're authenticated to GCP
$ gcloud auth list
```

```sh
# acquire credentials to use with Application Default Credentials
$ gcloud auth application-default login

```

```sh
# create function for convenience
$ function inspec-docker { docker run -it -e GOOGLE_AUTH_SUPPRESS_CREDENTIALS_WARNINGS=true --rm -v ~/.config:/root/.config -v $(pwd):/share cincproject/auditor:5.22.80 "$@"; }
```

```sh
# scan a project with this profile, replace {{project-id}} with your project ID
$ inspec-docker exec https://github.com/lxndrblz/inspec-gcp-cis-benchmark.git -t gcp:// --input gcp_project_id={{project-id}}  --reporter cli json:{{project-id}}_scan.json
...snip...
Profile Summary: 48 successful controls, 5 control failures, 7 controls skipped
Test Summary: 166 successful, 7 failures, 7 skipped
```

## ⚙️ Required APIs

Consider these GCP projects, which may all be the same or different:

- the project of the Service Account that's used to authenticate the scan
- the project from which the benchmark is called
- the project to be scanned

The following GCP APIs should be enabled in **all** of these projects:

- cloudkms.googleapis.com
- cloudresourcemanager.googleapis.com
- compute.googleapis.com
- dns.googleapis.com
- iam.googleapis.com
- logging.googleapis.com
- monitoring.googleapis.com
- sqladmin.googleapis.com
- storage-api.googleapis.com

## 🔑 Required Permissions

The following permissions are required to run the CIS benchmark profile:

On organization level:

- resourcemanager.organizations.get
- resourcemanager.projects.get
- resourcemanager.projects.getIamPolicy
- resourcemanager.folders.get

On project level:

- cloudkms.cryptoKeys.get
- cloudkms.cryptoKeys.getIamPolicy
- cloudkms.cryptoKeys.list
- cloudkms.keyRings.list
- cloudsql.instances.get
- cloudsql.instances.list
- compute.firewalls.get
- compute.firewalls.list
- compute.instances.get
- compute.instances.list
- compute.networks.get
- compute.networks.list
- compute.projects.get
- compute.regions.list
- compute.sslPolicies.get
- compute.sslPolicies.list
- compute.subnetworks.get
- compute.subnetworks.list
- compute.targetHttpsProxies.get
- compute.targetHttpsProxies.list
- compute.zones.list
- dns.managedZones.get
- dns.managedZones.list
- iam.serviceAccountKeys.list
- iam.serviceAccounts.list
- logging.logMetrics.list
- logging.sinks.get
- logging.sinks.list
- monitoring.alertPolicies.get
- monitoring.alertPolicies.list
- resourcemanager.projects.get
- resourcemanager.projects.getIamPolicy
- storage.buckets.get
- storage.buckets.getIamPolicy
- storage.buckets.list
