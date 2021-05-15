<p align="center"><img src="logo.png" width="400"></p>

# diploma

This diploma project is designed to interactively demonstrate the main aspects of information security using the most popular and demanded open source utilities.

## Usage

1. Clone this project and then cd to the project folder;
   
2. Init the server git submodule:
```
$ git submodule init
$ git submodule update --recursive
```

3. Now just run the main script file:
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
   * [pip3 for python](https://pip.pypa.io/en/stable/installing/)
   * [httperf](https://github.com/httperf/httperf)
   * [nmap](https://nmap.org/download.html)
   * [siege](https://github.com/JoeDog/siege)

4. Module:restore
   * [ext4magic](https://sourceforge.net/projects/ext4magic/)
   * [foremost](https://sourceforge.net/projects/foremost/)
   * [scalpel](https://github.com/sleuthkit/scalpel)


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
</details>

## License

This project is licensed under the [MIT License](LICENSE).
