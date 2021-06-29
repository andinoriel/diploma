# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.1 Final release] - 2021-06-29

### Added
* code documentation

## [1.2.0] - 2021-05-22

### Added
* docker-compose rules to containerizing test server

### Changed
* Test server is now using gunicorn

### Fixed
* Some bugs

## [1.1.1] - 2021-05-17

## Fixed
* Text's

## [1.1.0] - 2021-05-17

### Added
* Saving log mechanism using sqlite

### Fixed
* Some bugs

## [1.0.0] - 2021-05-15

### Changed
* First release - bump to v1.0.0

## [0.7.2] - 2021-05-15

### Added
* CtrlC interruption handling
* Force mode for network:nmap
* App colorize

### Changed
* App hello message

### Fixed
* Encryption:veracrypt verbose
* Module:restore output

## [0.7.1] - 2021-05-13

### Fixed
* Getting all partitions
* Root prompting
* Minor improvements

## [0.7.0] - 2021-05-12

### Added
* Benchmark for encryption:truecrypt
* Benchmark for encryption:veracrypt

### Fixed
* Some bugs

## [0.6.0] - 2021-05-12

### Added
* Network module: httperf

## [0.5.1] - 2021-05-10

### Added
* Server submodule for network:siege

### Changed
* Network module: Siege

### Fixed
* Multiple bugs

## [0.5.0] - 2021-05-09

### Added
* Network module: Siege(alpha)

### Changed
* Utility component
* Regular code refactor

## [0.4.0] - 2021-05-06

### Added
* Restore module: Scalpel
* Restore module: Foremost
* Restore module: ext4magic

### Changed
* Utility components
* Encryption modules: now works with both files and dirs

### Fixed
* Multiple bugs

## [0.3.0] - 2021-05-03

### Added
* Network module: Nmap
* NMap tcp scan
* NMap tcp syn scan
* NMap FIN scan
* NMap Xmax Tree scan
* NMap NULL scan
* NMap IP scan
* NMap ack scan
* NMap tcp window scan
* NMap rpc scan

### Changed
* Utility components

### Fixed
* Some utility bugs

## [0.2.0] - 2021-05-03

### Added
* Encryption module: VeraCrypt
* VeraCrypt:encryption
* VeraCrypt:decryption

### Changed
* Utility components

### Fixed
* Text strings in the interface

## [0.1.0] - 2021-05-02

### Added
* Base app dialog structure
* Encryption module: TrueCrypt
* TrueCrypt:encryption
* TrueCrypt:decryption
