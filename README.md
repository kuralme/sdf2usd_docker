# sdf2usd_docker
Simple to use, containerized environment to convert between SDF and USD files.

Main packages installed within the environment are:
- [USD](https://github.com/PixarAnimationStudios/OpenUSD/tree/v22.11) v22.11
- [Sdformat](https://github.com/gazebosim/sdformat) v12
- [gz-usd](https://github.com/gazebosim/gz-usd) an older branch uses sdf12

*Note:* Wasnt able to install sdformat13 with the currently so older version of gz-usd was including a fix.

## Usage
Scripts to build the docker image and run the container is added in the repo. Simply run:
```
bash build.sh
bash run.sh #You may need to install nvidia container toolkit
```