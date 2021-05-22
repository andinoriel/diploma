<p align="center"><img src="logo.png" width="400"></p>

# diploma

This diploma project is designed to interactively demonstrate the main aspects of information security using the most popular and demanded open source utilities.

## Usage

1. Clone this project and then cd to the project folder;

2. Now just run the main script file:
```
$ bash ./run.sh

OR

$ chmod +x ./run.sh
$ ./run.sh
```

## Requirements

Make sure you have installed these apps successfully before use this project:
1. Core
   * [bash](https://www.gnu.org/software/bash/)
   * [dialog](https://invisible-island.net/dialog/#download)

2. Module:encryption
   * [truecrypt](https://www.truecrypt71a.com/downloads/)
   * [veracrypt](https://www.veracrypt.fr/en/Downloads.html)

3. Module:network
   * [curl](https://curl.se/download.html)
   * [python3](https://www.python.org/downloads/)
   * [pip3 for python3](https://pip.pypa.io/en/stable/installing/)
   * [gunicorn for python3](https://gunicorn.org/)
   * [httperf](https://github.com/httperf/httperf)
   * [nmap](https://nmap.org/download.html)
   * [siege](https://github.com/JoeDog/siege)

  > Note than you also have ability to use python venv test server for testing purposes: [diploma-nms](https://github.com/andinoriel/diploma-nms)

4. Module:restore
   * [ext4magic](https://sourceforge.net/projects/ext4magic/)
   * [foremost](https://sourceforge.net/projects/foremost/)
   * [scalpel](https://github.com/sleuthkit/scalpel)


## Test server benchmarking

You can use benchmark for provided test server using it as a containerized docker image and testing it using (Google cAdvisor)[https://github.com/google/cadvisor]. For this:

1. Install [docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/);

2. Run the initial build of the environment for the test server:
```
$ cd ./extern
$ docker-compose build
```

3. Run the test server:
```
$ docker-compose up
```

4. Now run the Google cAdvisor utility using this command:
```
$ sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --name=cadvisor \
  gcr.io/cadvisor/cadvisor:v0.37.5
```

5. You've done! Test server is now online and await for clients on http://127.0.0.1:4723; you can inspect the running containerized test server on http://127.0.0.1:8080/docker/: just choose the 'extern_diploma_1' (or something like this) container.

## Screenshots

<details>
   <summary>Expand</summary>
   <img src="screenshots/Ask root.png" width="1280"/>
   <img src="screenshots/1 - hello1.png" width="1280"/>
   <img src="screenshots/1 - hello2.png" width="1280"/>
   <img src="screenshots/2 - Main menu.png" width="1280"/>
   <img src="screenshots/2.1 - Menu.png" width="1280"/>
   <img src="screenshots/2.1.1 - Menu.png" width="1280"/>
   <img src="screenshots/2.1.1.1 - Menu.png" width="1280"/>
   <img src="screenshots/2.1.1.1 - FD path dialog.png" width="1280"/>
   <img src="screenshots/2.1.1.1 - Algorithm dialog.png" width="1280"/>
   <img src="screenshots/2.1.1.1 - Password dialog.png" width="1280"/>
   <img src="screenshots/2.1.1.1 - Encryption.png" width="1280"/>
   <img src="screenshots/2.1.2 - Benchmark.png" width="1280"/>
   <img src="screenshots/2.2 - Menu.png" width="1280"/>
   <img src="screenshots/2.2.1 - Menu.png" width="1280"/>
   <img src="screenshots/2.2.1 - Scan.png" width="1280"/>
   <img src="screenshots/2.2.2 - Menu.png" width="1280"/>
   <img src="screenshots/2.2.2 - Test.png" width="1280"/>
   <img src="screenshots/2.2.3 - Menu.png" width="1280"/>
   <img src="screenshots/2.2.3 - Test.png" width="1280"/>
   <img src="screenshots/2.3 - Menu.png" width="1280"/>
   <img src="screenshots/2.3.1 - Menu.png" width="1280"/>
   <img src="screenshots/2.3.1 - Restore.png" width="1280"/>
   <img src="screenshots/2.3.2 - Restore.png" width="1280"/>
   <img src="screenshots/2.3.3 - Restore.png" width="1280"/>

   <img src="screenshots/cAdvisor - CPU.png" width="1280"/>
   <img src="screenshots/cAdvisor - Memory.png" width="1280"/>
   <img src="screenshots/cAdvisor - Network.png" width="1280"/>
</details>

## License

This project is licensed under the [MIT License](LICENSE).
