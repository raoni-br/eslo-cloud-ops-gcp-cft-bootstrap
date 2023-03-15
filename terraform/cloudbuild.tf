
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

// Comment-out the cloudbuild_bootstrap module and its outputs if you want to use Jenkins instead of Cloud Build
module "cloudbuild_bootstrap" {
  source                    = "terraform-google-modules/bootstrap/google//modules/cloudbuild"
  version                   = "~> 1.7"
  org_id                    = var.org_id
  folder_id                 = google_folder.bootstrap.id
  project_prefix            = "eslo"
  billing_account           = var.billing_account
  group_org_admins          = var.group_org_admins
  default_region            = var.default_region
  terraform_sa_email        = module.seed_bootstrap.terraform_sa_email
  terraform_sa_name         = module.seed_bootstrap.terraform_sa_name
  terraform_state_bucket    = module.seed_bootstrap.gcs_bucket_tfstate
  sa_enable_impersonation   = true
  skip_gcloud_download      = var.skip_gcloud_download
  create_cloud_source_repos = false

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
    "billingbudgets.googleapis.com"
  ]

  project_labels = {
    environment       = "foundation"
    application_name  = "eslo-foundation-cicd"
    business_code     = "org"
    env_code          = "f"
  }
}