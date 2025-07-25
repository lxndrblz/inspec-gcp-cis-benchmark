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

title 'Ensure That the Log Metric Filter and Alerts Exist for VPC Network Changes'

gcp_project_id = input('gcp_project_id')
cis_version = input('cis_version')
cis_url = input('cis_url')
control_id = '2.9'
control_abbrev = 'logging'

control "cis-gcp-#{control_id}-#{control_abbrev}" do
  impact 'low'

  title "[#{control_abbrev.upcase}] Ensure That the Log Metric Filter and Alerts Exist for VPC Network Changes"

  desc 'It is recommended that a metric filter and alarm be established for Virtual Private Cloud (VPC) network changes.'
  desc 'rationale', "It is possible to have more than one VPC within a project. In addition, it is also possible to create a peer connection between two VPCs enabling network traffic to route between VPCs.

  Monitoring changes to a VPC will help ensure VPC traffic flow is not getting impacted."

  tag cis_scored: true
  tag cis_level: 2
  tag cis_gcp: control_id.to_s
  tag cis_version: cis_version.to_s
  tag project: gcp_project_id.to_s
  tag nist: %w[AU-3 AU-12]

  ref 'CIS Benchmark', url: cis_url.to_s
  ref 'GCP Docs', url: 'https://cloud.google.com/logging/docs/logs-based-metrics/'
  ref 'GCP Docs', url: 'https://cloud.google.com/monitoring/custom-metrics/'
  ref 'GCP Docs', url: 'https://cloud.google.com/monitoring/alerts/'
  ref 'GCP Docs', url: 'https://cloud.google.com/logging/docs/reference/tools/gcloud-logging'
  ref 'GCP Docs', url: 'https://cloud.google.com/vpc/docs/overview'

  log_filter = 'resource.type=audited_resource AND jsonPayload.event_subtype="compute.networks.insert" OR jsonPayload.event_subtype="compute.networks.patch" OR jsonPayload.event_subtype="compute.networks.delete" OR jsonPayload.event_subtype="compute.networks.removePeering" OR jsonPayload.event_subtype="compute.networks.addPeering"'
  describe "[#{gcp_project_id}] VPC Network changes filter" do
    subject { google_project_metrics(project: gcp_project_id).where(metric_filter: log_filter) }
    it { should exist }
  end

  google_project_metrics(project: gcp_project_id).where(metric_filter: log_filter).metric_types.each do |metrictype|
    describe.one do
      filter = "metric.type=\"#{metrictype}\" resource.type=\"audited_resource\""
      google_project_alert_policies(project: gcp_project_id).where(policy_enabled_state: true).policy_names.each do |policy|
        condition = google_project_alert_policy_condition(policy: policy, filter: filter)
        describe "[#{gcp_project_id}] VPC Network changes alert policy" do
          subject { condition }
          it { should exist }
        end
      end
    end
  end
end
