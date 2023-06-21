# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.0.0](https://github.com/voxpupuli/puppet-catalog_diff/tree/v4.0.0) (2023-06-21)

[Full Changelog](https://github.com/voxpupuli/puppet-catalog_diff/compare/v3.0.0...v4.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#98](https://github.com/voxpupuli/puppet-catalog_diff/pull/98) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add puppet 8 support [\#97](https://github.com/voxpupuli/puppet-catalog_diff/pull/97) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- switch from camptocamp to voxpupuli module [\#96](https://github.com/voxpupuli/puppet-catalog_diff/pull/96) ([tuxmea](https://github.com/tuxmea))

## [v3.0.0](https://github.com/voxpupuli/puppet-catalog_diff/tree/v3.0.0) (2022-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-catalog_diff/compare/v2.3.0...v3.0.0)

**Breaking changes:**

- Remove legacy Puppet manifest [\#36](https://github.com/voxpupuli/puppet-catalog_diff/pull/36) ([raphink](https://github.com/raphink))

**Implemented enhancements:**

- Document fact bootstrapping for new puppetserver [\#89](https://github.com/voxpupuli/puppet-catalog_diff/pull/89) ([bastelfreak](https://github.com/bastelfreak))
- Support custom TLS certificates for old Puppetserver [\#87](https://github.com/voxpupuli/puppet-catalog_diff/pull/87) ([bastelfreak](https://github.com/bastelfreak))
- Add support for custom certificates to old PuppetDB [\#72](https://github.com/voxpupuli/puppet-catalog_diff/pull/72) ([bastelfreak](https://github.com/bastelfreak))
- Add Puppet 7 support [\#70](https://github.com/voxpupuli/puppet-catalog_diff/pull/70) ([bastelfreak](https://github.com/bastelfreak))
- Implement support for custom PuppetDB URLs [\#68](https://github.com/voxpupuli/puppet-catalog_diff/pull/68) ([bastelfreak](https://github.com/bastelfreak))
- comparer: exit early if checksum in old/new catalog is equal [\#65](https://github.com/voxpupuli/puppet-catalog_diff/pull/65) ([bastelfreak](https://github.com/bastelfreak))
- compilecatalog: Switch to new HTTP client implementation [\#61](https://github.com/voxpupuli/puppet-catalog_diff/pull/61) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- comparer: exit earily if old/new contents are empty [\#66](https://github.com/voxpupuli/puppet-catalog_diff/pull/66) ([bastelfreak](https://github.com/bastelfreak))
- Don't format Floats as Strings [\#54](https://github.com/voxpupuli/puppet-catalog_diff/pull/54) ([alexjfisher](https://github.com/alexjfisher))

**Closed issues:**

- node\_list doesn't work as intended [\#62](https://github.com/voxpupuli/puppet-catalog_diff/issues/62)
- Migrating this Repository to Voxpupuli [\#60](https://github.com/voxpupuli/puppet-catalog_diff/issues/60)
- doing diff on same node - 2 different environments? [\#41](https://github.com/voxpupuli/puppet-catalog_diff/issues/41)
- Saving a report doesn't work when passing two catalogs into the CLI [\#37](https://github.com/voxpupuli/puppet-catalog_diff/issues/37)

**Merged pull requests:**

- Document talks/blogposts about puppet-catalog-diff [\#86](https://github.com/voxpupuli/puppet-catalog_diff/pull/86) ([bastelfreak](https://github.com/bastelfreak))
- Document --certless advantage/trusted facts setup [\#85](https://github.com/voxpupuli/puppet-catalog_diff/pull/85) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: various small cleanups part 4 [\#84](https://github.com/voxpupuli/puppet-catalog_diff/pull/84) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: various small cleanups part 3 [\#83](https://github.com/voxpupuli/puppet-catalog_diff/pull/83) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: various small cleanups part 1 [\#82](https://github.com/voxpupuli/puppet-catalog_diff/pull/82) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: various small cleanups part 1 [\#81](https://github.com/voxpupuli/puppet-catalog_diff/pull/81) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Style/TrailingCommaInArguments [\#80](https://github.com/voxpupuli/puppet-catalog_diff/pull/80) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Style/SymbolProc [\#79](https://github.com/voxpupuli/puppet-catalog_diff/pull/79) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Style/BlockDelimiters [\#78](https://github.com/voxpupuli/puppet-catalog_diff/pull/78) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Layout/IndentationWidth [\#77](https://github.com/voxpupuli/puppet-catalog_diff/pull/77) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Layout/EmptyLineAfterGuardClause [\#76](https://github.com/voxpupuli/puppet-catalog_diff/pull/76) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Layout/IndentationConsistency [\#75](https://github.com/voxpupuli/puppet-catalog_diff/pull/75) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Layout/EndAlignment [\#74](https://github.com/voxpupuli/puppet-catalog_diff/pull/74) ([bastelfreak](https://github.com/bastelfreak))
- rubocop: Fix Layout/ElseAlignment [\#73](https://github.com/voxpupuli/puppet-catalog_diff/pull/73) ([bastelfreak](https://github.com/bastelfreak))
- Clarify supported Puppet versions in README.md [\#71](https://github.com/voxpupuli/puppet-catalog_diff/pull/71) ([bastelfreak](https://github.com/bastelfreak))
- Cleanup old code [\#67](https://github.com/voxpupuli/puppet-catalog_diff/pull/67) ([bastelfreak](https://github.com/bastelfreak))
- comparer: cleanup trailing whitespace [\#64](https://github.com/voxpupuli/puppet-catalog_diff/pull/64) ([bastelfreak](https://github.com/bastelfreak))
- auth.conf: Document how to update it with Puppet [\#63](https://github.com/voxpupuli/puppet-catalog_diff/pull/63) ([bastelfreak](https://github.com/bastelfreak))
- Adding --node\_list option [\#55](https://github.com/voxpupuli/puppet-catalog_diff/pull/55) ([serialh0bbyist](https://github.com/serialh0bbyist))
- Make --output\_report work when diffing two catalog files or directories. [\#50](https://github.com/voxpupuli/puppet-catalog_diff/pull/50) ([natemccurdy](https://github.com/natemccurdy))
- Prevent 'false' from showing up in the console report [\#49](https://github.com/voxpupuli/puppet-catalog_diff/pull/49) ([natemccurdy](https://github.com/natemccurdy))
- README.md: fix installation command [\#48](https://github.com/voxpupuli/puppet-catalog_diff/pull/48) ([aerickson](https://github.com/aerickson))
- Fix `threads` option in `pull` face [\#40](https://github.com/voxpupuli/puppet-catalog_diff/pull/40) ([alexjfisher](https://github.com/alexjfisher))
- Adds backward compatibility with older version of PuppetDB used in Puppet 3, to support Puppet 3 to 5 upgrades [\#39](https://github.com/voxpupuli/puppet-catalog_diff/pull/39) ([JohnEricson](https://github.com/JohnEricson))
- Fix "Error: invalid byte sequence in UTF-8" error when retrieving catalogues with invalid encoding from PuppetDB on Puppet 3 server [\#38](https://github.com/voxpupuli/puppet-catalog_diff/pull/38) ([JohnEricson](https://github.com/JohnEricson))

## [v2.3.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.3.0) (2020-08-18)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v2.2.1...v2.3.0)

### Added

- Use `prefer\_requested\_environment` `true` [\#35](https://github.com/camptocamp/puppet-catalog-diff/pull/35) ([alexjfisher](https://github.com/alexjfisher))
- Include list of `all\_changed\_nodes` in json report [\#34](https://github.com/camptocamp/puppet-catalog-diff/pull/34) ([alexjfisher](https://github.com/alexjfisher))
- Hide sensitive parameters [\#33](https://github.com/camptocamp/puppet-catalog-diff/pull/33) ([alexjfisher](https://github.com/alexjfisher))
- Add link to upload\_facts.rb script and documentation how to use it in Puppet upgrades to README [\#30](https://github.com/camptocamp/puppet-catalog-diff/pull/30) ([JohnEricson](https://github.com/JohnEricson))

## [v2.2.1](https://github.com/camptocamp/puppet-catalog-diff/tree/v2.2.1) (2020-07-15)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v2.2.0...v2.2.1)

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

- Use \#notice instead of \#err for realtime message [\#26](https://github.com/camptocamp/puppet-catalog-diff/pull/26) ([raphink](https://github.com/raphink))
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

## [v1.7.0](https://github.com/camptocamp/puppet-catalog-diff/tree/v1.7.0) (2020-05-05)

[Full Changelog](https://github.com/camptocamp/puppet-catalog-diff/compare/v1.6.0...v1.7.0)

### Added

- Refactor [\#14](https://github.com/camptocamp/puppet-catalog-diff/pull/14) ([raphink](https://github.com/raphink))
- Lint [\#13](https://github.com/camptocamp/puppet-catalog-diff/pull/13) ([raphink](https://github.com/raphink))
- Ignore parameters [\#12](https://github.com/camptocamp/puppet-catalog-diff/pull/12) ([raphink](https://github.com/raphink))
- Sort hash keys in formater [\#11](https://github.com/camptocamp/puppet-catalog-diff/pull/11) ([raphink](https://github.com/raphink))
- Include environment in report [\#10](https://github.com/camptocamp/puppet-catalog-diff/pull/10) ([raphink](https://github.com/raphink))
- Update to current PDK template [\#9](https://github.com/camptocamp/puppet-catalog-diff/pull/9) ([DavidS](https://github.com/DavidS))
- Cache str diffs [\#8](https://github.com/camptocamp/puppet-catalog-diff/pull/8) ([raphink](https://github.com/raphink))
- Puppetdb catalog [\#7](https://github.com/camptocamp/puppet-catalog-diff/pull/7) ([raphink](https://github.com/raphink))
- Output endpoint in debug [\#6](https://github.com/camptocamp/puppet-catalog-diff/pull/6) ([raphink](https://github.com/raphink))
- Support certless API [\#3](https://github.com/camptocamp/puppet-catalog-diff/pull/3) ([raphink](https://github.com/raphink))
- Use v3 catalog API [\#2](https://github.com/camptocamp/puppet-catalog-diff/pull/2) ([raphink](https://github.com/raphink))

### Fixed

- Fix: v4/catalog returns an embedded catalog [\#5](https://github.com/camptocamp/puppet-catalog-diff/pull/5) ([raphink](https://github.com/raphink))
- Check key in parsed catalog [\#1](https://github.com/camptocamp/puppet-catalog-diff/pull/1) ([raphink](https://github.com/raphink))

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
