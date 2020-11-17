class DeploymentPayload {
    
    constructor(context, core, github) {
        this.context = context;
        this.core = core;
        this.github = github;
    }

    // Unpacks the deployment payload and sets them as outputs then reports a deployment status
    async unpackAndStart() {
        const context = this.context
            , github = this.github
            , core = this.core
            , run = process.env.GITHUB_RUN_ID
            , log_url = `https://github.com/${context.repo.owner}/${context.repo.repo}/actions/runs/${run}`
            ;

        const deployment = context.payload.deployment
            , environment = deployment.environment
            , deploymentPayload = JSON.parse(deployment.payload)
            ;

        core.setOutput('app_container_image', deploymentPayload.app_container.image);
        core.setOutput('app_container_version', deploymentPayload.app_container.version);

        core.setOutput('database_container_image', deploymentPayload.database_container.image);
        core.setOutput('database_container_version', deploymentPayload.database_container.version);

        core.setOutput('deployment_sha', deploymentPayload.sha);
        core.setOutput('deployment_github_ref', deploymentPayload.ref);

        core.setOutput('environment', environment);

        core.setOutput('container_registry', deploymentPayload.container_registry);
        
        
        github.repos.createDeploymentStatus({
            ...this.context.repo,
            mediaType: {
                previews: ["flash-preview", "ant-man"]
            },
            deployment_id: context.payload.deployment.id,
            state: 'in_progress',
            description: 'Deployment from GitHub Actions started',
            target_url: log_url,
            log_url: log_url
        });
    }
}

module.exports = (context, core, github) => {
    return new DeploymentPayload(context, core, github);
}
