remote_state {
    backend         = "gcs"

    generate = {
        path        = "backend.generated.tf"
        if_exists   = "overwrite_terragrunt"
    }

    config = {
        bucket      = "octodemo-db-bookstore"
        prefix      = "kube-${get_env("KUBE_SYSTEM", "plain")}-${get_env("TF_VAR_ENVIRONMENT", "integration")}.terraform.state"
    }
}
