module.exports = {
    apps: [
      {
        name: "app-backend",
        script: "lerna run dev:serve --scope=@rpi3-app/backend",
        cwd: "app/backend",
        log_file: "../../logs/backend-srv.log"
      },
      {
        name: "app-frontend",
        script: "lerna run dev:build --scope=@rpi3-app/frontend",
        cwd: "app/frontend",
        log_file: "../../logs/frontend-ui.log"
      },
      
    ]
  }