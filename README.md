## Golf Scores
This is a simple app used for bragging rights around the office.

http://golf.riesd.com/

## Running in Development Mode
This repository just acts as the backend of the application. It does not contain any frontend code.

Please see mmmries/golfscore-frontend to get a copy of the frontend.

For development purposes I usually have the webserver running the frontend code just proxy to this project running locally.

You can start this project with a simple <code>rackup</code> command.

## Deploying the App
This app is setup to use Docker and its docker images can be found at https://registry.hub.docker.com/u/hqmq/golf/

To build a new image run the following docker commands:

```
docker build -t hqmq/golf:0.0.8 .
docker push hqmq/golf:0.0.8
docker tag hqmq/golf:0.0.8 hqmq/golf:latest
docker push hqmq/golf:latest
```

To run an image use the following docker command (you'll want to substitue the version tag at the end to be the latest version you created)
```
docker pull hqmq/golf:latest
docker run -d --name golf -v /root/db:/home/app/db -p 4000:80 hqmq/golf:latest
```
