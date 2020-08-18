# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v2.2.1](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.2.1) (2020-08-18)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v2.2.1...v2.2.1)

### Added

- Use `prefer\_requested\_environment` `true` [\#35](https://github.com/camptocamp/puppet-catalog-diff/pull/35) ([alexjfisher](https://github.com/alexjfisher))
- Include list of `all\_changed\_nodes` in json report [\#34](https://github.com/camptocamp/puppet-catalog-diff/pull/34) ([alexjfisher](https://github.com/alexjfisher))
- Hide sensitive parameters [\#33](https://github.com/camptocamp/puppet-catalog-diff/pull/33) ([alexjfisher](https://github.com/alexjfisher))
- Add link to upload\_facts.rb script and documentation how to use it in Puppet upgrades to README [\#30](https://github.com/camptocamp/puppet-catalog-diff/pull/30) ([JohnEricson](https://github.com/JohnEricson))

## [v2.2.1](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.2.1) (2020-07-15)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v2.2.0...v2.2.1)

### Added

- Use \#notice instead of \#err for realtime message [\#26](https://github.com/camptocamp/puppet-catalog-diff/pull/26) ([raphink](https://github.com/raphink))

### Fixed

- Get rid of obsolete URI.escape [\#29](https://github.com/camptocamp/puppet-catalog-diff/pull/29) ([raphink](https://github.com/raphink))
- Fix problem where a node's details wouldn't load/show in puppet-catalog-diff-viewer [\#28](https://github.com/camptocamp/puppet-catalog-diff/pull/28) ([JohnEricson](https://github.com/JohnEricson))

## [v2.2.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.2.0) (2020-06-19)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v2.1.1...v2.2.0)

### Added

- Add --exclude\_resource\_types= flag [\#27](https://github.com/camptocamp/puppet-catalog-diff/pull/27) ([raphink](https://github.com/raphink))

## [v2.1.1](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.1.1) (2020-06-10)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v2.1.0...v2.1.1)

## [v2.1.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.1.0) (2020-06-10)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v2.0.0...v2.1.0)

### Added

- Add --exclude\_defined\_resources [\#25](https://github.com/camptocamp/puppet-catalog-diff/pull/25) ([raphink](https://github.com/raphink))

## [v2.0.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.0.0) (2020-05-05)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v1.7.0...v2.0.0)

### Changed

- Decommission old fact\_search methods [\#17](https://github.com/camptocamp/puppet-catalog-diff/pull/17) ([raphink](https://github.com/raphink))

### Added

- Add coveralls [\#20](https://github.com/camptocamp/puppet-catalog-diff/pull/20) ([raphink](https://github.com/raphink))
- Test comparer [\#18](https://github.com/camptocamp/puppet-catalog-diff/pull/18) ([raphink](https://github.com/raphink))
- Update Readme [\#16](https://github.com/camptocamp/puppet-catalog-diff/pull/16) ([raphink](https://github.com/raphink))
- Refactor/lint [\#15](https://github.com/camptocamp/puppet-catalog-diff/pull/15) ([raphink](https://github.com/raphink))

### Fixed

- Fix convert\_pdb [\#21](https://github.com/camptocamp/puppet-catalog-diff/pull/21) ([raphink](https://github.com/raphink))

## [v1.6.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v1.6.0) (2015-06-04)
[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v1.5.2...v1.6.0)

- The generation date (global info)
- Two node fields: old_version and new_version, using the catalog versions. [\#8](https://github.com/acidprime/puppet-catalog-diff/pull/8) ([raphink](https://github.com/raphink))

## [v1.5.2](https://github.com/camptocamp/puppet-catalog-diff/tree/v1.5.2) (2015-06-03)
[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v1.5.1...v1.5.2)

- Improve puppetdb requests [\#7](https://github.com/acidprime/puppet-catalog-diff/pull/7) ([raphink](https://github.com/raphink))

## [v1.5.1](https://github.com/camptocamp/puppet-catalog-diff/tree/v1.5.1) (2015-06-02)
[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v1.5.0...v1.5.1)

- Fix Typo [\#6](https://github.com/acidprime/puppet-catalog-diff/pull/6) ([claytono](https://github.com/claytono))

## [v1.5.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v1.5.0) (2015-06-02)
[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v1.0.0...v1.5.0)

- Multiple facts in filter [\#5](https://github.com/acidprime/puppet-catalog-diff/pull/5) ([raphink](https://github.com/raphink))
- Allow for filtering of local yaml cache [\#4](https://github.com/acidprime/puppet-catalog-diff/pull/4) ([raphink](https://github.com/raphink))
- Allow you to pass environment [\#2](https://github.com/acidprime/puppet-catalog-diff/pull/2) ([raphink](https://github.com/raphink))
- Update error handling [\#1](https://github.com/acidprime/puppet-catalog-diff/pull/1) ([supercow](https://github.com/supercow))
- [Update puppedb option handling](https://github.com/acidprime/puppet-catalog-diff/commit/c567a48fe75715a1d30e1d02dcc49c339b470cb8) ([raphink](https://github.com/raphink))

## [v1.0.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v1.0.0) (2015-06-02)

- Initial fork and release of RIAAs build ([acidprime](https://github.com/acidprime))


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
