module.exports = {
  branches: ["master"],
  tagFormat: "v${version}",
  repositoryUrl: "https://github.com/mac-ci-png/mparticle-apple-sdk",
  plugins: [
    [
      "@semantic-release/commit-analyzer",
      {
        preset: "angular",
      },
    ],
    [
      "@semantic-release/release-notes-generator",
      {
        preset: "angular",
      },
    ],
    [
      "@semantic-release/changelog",
      {
        changelogFile: "CHANGELOG.md",
      },
    ],
    [
      "@semantic-release/exec",
      {
        prepareCmd: "sh ./Scripts/release.sh ${nextRelease.version} \"${nextRelease.notes}\"",
      },
    ],
    [
      "@semantic-release/git",
      {
        assets: [
          "mParticle-Apple-SDK/MPIConstants.m",
          "Framework/Info.plist",
          "mParticle-Apple-SDK.podspec",
          "mParticle_Apple_SDK.json",
          "CHANGELOG.md",
        ],
        message:
          "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}",
      },
    ],
    [
      "@semantic-release/github",
      {
        assets: [
          "mParticle_Apple_SDK.framework.zip",
          "mParticle_Apple_SDK.framework.nolocation.zip",
          "mParticle_Apple_SDK.xcframework.zip",
          "mParticle_Apple_SDK.xcframework.nolocation.zip",
          "generated-docs.zip",
        ],
      },
    ],
  ],
};
