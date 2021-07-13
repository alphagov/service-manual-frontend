# Service Manual Frontend

Service Manual Frontend is a public-facing app to display the service manual formats on GOV.UK.

## Technical documentation

This is a Ruby on Rails application that fetches documents from
[content-store](https://github.com/alphagov/content-store) and displays them.

### Dependencies

- [content-store](https://github.com/alphagov/content-store) - provides documents
- [static](https://github.com/alphagov/static) - provides shared GOV.UK assets and templates.

## Development notes

The application *does not serve content at its root (/)* - the
homepage will be found at service-manual-frontend.dev.gov.uk/service-manual but
only if the content item for the homepage exists in the content store.

You can achieve this by restoring from a production backup, publishing the home
page using the rake task in service-manual-publisher or by using the dummy
content store.

### Running the test suite

The test suite relies on the presence of the
[govuk-content-schemas](http://github.com/alphagov/govuk-content-schemas)
repository. If it is present at the same directory level as
the service-manual-frontend repository then run the tests with:

`bundle exec rake`

Or to specify the location explicitly:

`GOVUK_CONTENT_SCHEMAS_PATH=/some/dir/govuk-content-schemas bundle exec rake`

### Use of BEM

The Service manual frontend application uses a modified version of [the BEM methodology](https://en.bem.info),
coined by [Harry Roberts](https://en.bem.info/methodology/naming-convention/#alternative-naming-schemes).

It uses the following conventions:
* block, element and modifier names are written in lower case
* words within the names of BEM entities are separated by a hyphen (-)
* an element name is separated from a block name by a double underscore (__)
* modifiers are delimited by double hyphens (--)
* [Key-value type modifiers](https://en.bem.info/methodology/naming-convention/#element-modifier) are not used

A block:

    .button

An element:

    .button__icon

A modifier:

    .button--large


## Licence

[MIT License](LICENCE)
