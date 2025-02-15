module.exports = {
  branchPrefix: "renovate-bot/",
  username: "hibiscus-collective-renovate",
  gitAuthor: "Renovate Bot <bot@renovateapp.com>",
  onboarding: false,
  platform: "github",
  forkProcessing: "enabled",
  dryRun: "full",
  repositories: ["HibiscusCollective/project-template"],
  packageRules: [
    {
      description: "lockFileMaintenance",
      matchUpdateTypes: [
        "pin",
        "digest",
        "patch",
        "minor",
        "major",
        "lockFileMaintenance",
      ],
      dependencyDashboardApproval: false,
      minimumReleaseAge: "0 days",
    },
  ],
};
