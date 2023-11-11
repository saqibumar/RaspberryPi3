module.exports = {
    apps: [
      {
        name: "app-backend",
        script: "lerna run dev:serve --scope=@rp3-app/backend",
        cwd: "app/backend",
        log_file: "../../logs/roaster-srv.log"
      },
      {
        name: "app-frontend",
        script: "lerna run dev:build --scope=@rp3-app/frontend",
        cwd: "app/frontend",
        log_file: "../../logs/app-frontend.log"
      },
      
    ]
  }