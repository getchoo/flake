{
  githubWorkflowGenerator = {
    outputs = [
      "checks"
      "devShells"
      "nixosConfigurations"
      "darwinConfigurations"
    ];

    overrides = {
      app.systems = ["x86_64-linux"];
      checks.systems = ["x86_64-linux"];
      devShells.systems = ["x86_64-linux"];
    };
  };
}
