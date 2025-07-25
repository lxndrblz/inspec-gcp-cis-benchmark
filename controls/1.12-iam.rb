# Copyright 2019 The inspec-gcp-cis-benchmark Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

title 'Ensure API Keys Only Exist for Active Services'

gcp_project_id = input('gcp_project_id')
cis_version = input('cis_version')
cis_url = input('cis_url')
control_id = '1.12'
control_abbrev = 'iam'

control "cis-gcp-#{control_id}-#{control_abbrev}" do
  impact 'medium'

  title "[#{control_abbrev.upcase}] Ensure API Keys Only Exist for Active Services"

  desc 'API Keys should only be used for services in cases where other authentication methods are unavailable. Unused keys with their permissions in tact may still exist within a project. Keys are insecure because they can be viewed publicly, such as from within a browser, or they can be accessed on a device where the key resides. It is recommended to use standard authentication flow instead.'
  desc 'rationale', "To avoid the security risk in using API keys, it is recommended to use standard authentication flow instead. Security risks involved in using API-Keys appear below:
  - API keys are simple encrypted strings
  - API keys do not identify the user or the application making the API request
  - API keys are typically accessible to clients, making it easy to discover and steal an API key"

  tag cis_scored: false
  tag cis_level: 2
  tag cis_gcp: control_id.to_s
  tag cis_version: cis_version.to_s
  tag project: gcp_project_id.to_s
  tag nist: ['AC-2']

  ref 'CIS Benchmark', url: cis_url.to_s
  ref 'GCP Docs', url: 'https://cloud.google.com/docs/authentication/api-keys'
  ref 'GCP Docs', url: 'https://cloud.google.com/sdk/gcloud/reference/services/api-keys/list'
  ref 'GCP Docs', url: 'https://cloud.google.com/docs/authentication'
  ref 'GCP Docs', url: 'https://cloud.google.com/sdk/gcloud/reference/services/api-keys/delete'
  describe 'This control is not scored' do
    skip 'This control is not scored'
  end
end
