module.exports = {
  branchPrefix: "renovate-bot/",
  username: "hibiscus-collective-renovate",
  gitAuthor: "Renovate Bot <bot@renovateapp.com>",
  onboarding: false,
  requireConfig: "optional",
  platform: "github",
  forkProcessing: "enabled",
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
    {
      matchUpdateTypes: [
        "minor",
        "patch",
        "pin",
        "pinDigest",
        "digest",
        "lockFileMaintenance",
      ],
      groupName: "minor-updates",
    },
    {
      matchUpdateTypes: ["major"],
      label: ["Major Release"],
    },
  ],
};
