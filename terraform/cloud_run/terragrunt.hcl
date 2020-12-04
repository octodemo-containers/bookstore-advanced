remote_state {
    backend         = "gcs"

    generate = {
        path        = "backend.generated.tf"
        if_exists   = "overwrite_terragrunt"
    }

    config = {
        bucket      = "octodemo-containers-bookstore"
        prefix      = "cloud-run-${get_env("TF_VAR_ENVIRONMENT", "integration")}.terraform.state"
    }
}
