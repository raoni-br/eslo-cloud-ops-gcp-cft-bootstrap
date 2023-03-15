
/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource google_folder bootstrap {
  display_name = "eslo-bootstrap"
  parent       = local.parent

  depends_on = [google_organization_iam_member.create_folder_member]
}

module seed_bootstrap {
  source  = "terraform-google-modules/bootstrap/google"
  version = "~> 1.7"

  org_id                         = var.org_id
  folder_id                      = google_folder.bootstrap.id
  billing_account                = var.billing_account
  group_org_admins               = var.group_org_admins
  group_billing_admins           = var.group_billing_admins
  default_region                 = var.default_region
  project_prefix                 = "eslo"
  org_project_creators           = var.org_project_creators
  sa_enable_impersonation        = true
  parent_folder                  = var.parent_folder == "" ? "" : local.parent
  skip_gcloud_download           = var.skip_gcloud_download
  org_admins_org_iam_permissions = local.org_admins_org_iam_permissions

  project_labels = {
    environment      = "foundation"
    application_name = "eslo-gcp-foundation"
    business_code    = "org"
    env_code         = "f"
  }

  activate_apis = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "securitycenter.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "billingbudgets.googleapis.com",

    "sqladmin.googleapis.com",
    "cloudbuild.googleapis.com",
  ]

  sa_org_iam_permissions = [
    "roles/accesscontextmanager.policyAdmin",
    "roles/billing.user",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.configWriter",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderAdmin",
    "roles/securitycenter.notificationConfigEditor",
    "roles/resourcemanager.organizationViewer"
  ]
}

resource google_billing_account_iam_member tf_billing_admin {
  billing_account_id = var.billing_account
  role               = "roles/billing.admin"
  member             = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"
}

resource google_organization_iam_member create_folder_member {
  org_id = var.org_id
  role   = "roles/resourcemanager.folderCreator"
  member = "group:${var.group_org_admins}"
}

resource google_organization_iam_member org_viewer_member {
  org_id = var.org_id
  role   = "roles/viewer"
  member = "group:${var.group_org_admins}"
}
