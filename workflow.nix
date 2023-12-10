{
  githubWorkflowGenerator = {
    outputs = [
      "checks"
      "devShells"
      "darwinConfigurations"
      "nixosConfigurations"
      "homeConfigurations"
    ];

    overrides = {
      checks.systems = ["x86_64-linux"];
      devShells.systems = ["x86_64-linux" "x86_64-darwin"];
    };
  };
}
