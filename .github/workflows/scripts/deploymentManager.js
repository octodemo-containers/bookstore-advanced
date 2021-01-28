module.exports = class DeploymentManager {

  constructor(context, github) {
    this.context = context;
    this.github = github;
  }

  async activateDeployment(deploymentId, environmentUrl) {
    const github = this.github,
      context = this.context,
      url = this.cleanEnvironmentUrl(environmentUrl);

    console.log(`Deployed Environment url: '${url}'`);

    const deployment = await github.repos.getDeployment({
      ...context.repo,
      deployment_id: deploymentId
    }).then(resp => {
      return resp.data;
    });

    // Activate the deployment
    await github.repos.createDeploymentStatus({
      ...context.repo,
      deployment_id: deployment.id,
      state: 'success',
      environment_url: url,
      mediaType: {
        previews: ['ant-man', 'flash']
      }
    });

    // Get all deployments for the specified environment
    const allDeployments = await this.getAllDeployments(deployment.environment)

    // Inactivate any previous environments
    const promises = [];

    allDeployments.forEach(deployment => {
      // If this a previous deployment, ensure it is inactive.
      if (deployment.id !== deploymentId) {
        promises.push(this.inactivateDeployment(deployment.id));
      }
    });

    return Promise.all(promises);
  }

  cleanEnvironmentUrl(envUrl) {
    // Terraform has started putting out quoted strings now, so we have to clean them up
    let result = envUrl.trim();

    const regex = /^"(.*)"$/;
    if (regex.test(result)) {
      result = regex.exec(result)[1]
    }
    return result;
  }

  async deactivateIntegrationDeployments(ref) {
    const context = this.context,
      github = this.github;

    //TODO might need to contend with pagination, but in practice this should not be an issue as we are limiting on ref
    return github.repos.listDeployments({
      ...context.repo,
      ref: ref,
      per_page: 100,
    }).then(deployments => {
      const promises = [];

      deployments.data.forEach(deployment => {
        promises.push(
          github.repos.listDeploymentStatuses({
            ...context.repo,
            deployment_id: deployment.id,
            per_page: 100,
          }).then(statuses => {
            if (statuses.data) {
              // The first state is the most current state for the deployment
              const currentState = statuses.data[0];

              // Ignore deployments that are already inactive
              if (currentState !== 'inactive') {

                // Ignore environments that are already in failure state
                if (currentState !== 'failure') {
                  console.log(`Deployment: ${deployment.id}:${deployment.environment} transitioning to failure`);
                  return github.repos.createDeploymentStatus({
                    ...context.repo,
                    mediaType: { previews: ["flash", "ant-man"] },
                    deployment_id: deployment.id,
                    state: 'failure',
                    description: 'Pull Request Merged/Closed, triggering removal'
                  }).then(() => {
                    console.log(`Deployment: ${deployment.id}:${deployment.environment} transitioning to inactive`);
                    return github.repos.createDeploymentStatus({
                      ...context.repo,
                      mediaType: { previews: ["flash", "ant-man"] },
                      deployment_id: deployment.id,
                      state: 'inactive',
                      description: 'Pull Request Merged/Closed, inactivating'
                    });
                  });
                }
              }
            }
          })
        );
      });

      return Promise.all(promises);
    });
  }

  async getAllDeployments(environment) {
    const context = this.context;

    return this.github.paginate('GET /repos/:owner/:repo/deployments', {
      ...context.repo,
      environment: environment
    });
  }

  async inactivateDeployment(deploymentId) {
    const context = this.context,
      github = this.github;

    //TODO this may not be necessary as we should not have a long list of deployment statuses, we could just use listDeploymentStatuses()
    return github.paginate('GET /repos/:owner/:repo/deployments/:deployment_id/statuses', {
      ...context.repo,
      deployment_id: deploymentId
    }).then(statuses => {
      if (statuses && statuses.length > 0) {
        const currentStatus = statuses[0].state;

        if (currentStatus !== 'inactive') {
          return github.repos.createDeploymentStatus({
            ...context.repo,
            deployment_id: deploymentId,
            state: 'inactive',
            mediaType: { previews: ['flash', 'ant-man'] }
          });
        }
      }
    });
  }
}