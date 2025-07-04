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

title 'Ensure Legacy Networks Do Not Exist for Older Projects'

gcp_project_id = input('gcp_project_id')
cis_version = input('cis_version')
cis_url = input('cis_url')
control_id = '3.2'
control_abbrev = 'networking'

control "cis-gcp-#{control_id}-#{control_abbrev}" do
  impact 'medium'

  title "[#{control_abbrev.upcase}] Ensure Legacy Networks Do Not Exist for Older Projects"

  desc 'In order to prevent use of legacy networks, a project should not have a legacy network configured. As of now, Legacy Networks are gradually being phased out, and you can no longer create projects with them. This recommendation is to check older projects to ensure that they are not using Legacy Networks.'
  desc 'rationale', 'Legacy networks have a single network IPv4 prefix range and a single gateway IP address for the whole network. The network is global in scope and spans all cloud regions. Subnetworks cannot be created in a legacy network and are unable to switch from legacy to auto or custom subnet networks. Legacy networks can have an impact for high network traffic projects and are subject to a single point of contention or failure.'

  tag cis_scored: true
  tag cis_level: 1
  tag cis_gcp: control_id.to_s
  tag cis_version: cis_version.to_s
  tag project: gcp_project_id.to_s
  tag nist: ['CM-6']

  ref 'CIS Benchmark', url: cis_url.to_s
  ref 'GCP Docs', url: 'https://cloud.google.com/compute/docs/networking#creating_a_legacy_network'
  ref 'GCP Docs', url: 'https://cloud.google.com/vpc/docs/using-legacy#deleting_a_legacy_network'

  network_names = google_compute_networks(project: gcp_project_id).network_names

  if network_names.empty?
    describe "[#{gcp_project_id}] does not have any networks. This test is Not Applicable." do
      skip "[#{gcp_project_id}] does not have any networks."
    end
  else
    google_compute_networks(project: gcp_project_id).network_names.each do |network|
      describe "[#{gcp_project_id}] Network [#{network}] " do
        subject { google_compute_network(project: gcp_project_id, name: network) }
        it { should_not be_legacy }
      end
    end
  end
end
