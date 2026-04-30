# Reports

Reports are formatters that turn the in-memory list of packages and
their decisions into something human- or machine-readable.

## Built-in formats

| Format | Class | Notes |
| --- | --- | --- |
| `text` | `LicenseFinder::TextReport` | Default for `action_items` |
| `csv` | `LicenseFinder::CsvReport` | Configurable columns |
| `html` | `LicenseFinder::HtmlReport` | Uses ERB templates in `reports/templates/` |
| `markdown` | `LicenseFinder::MarkdownReport` | Friendly for PR comments |
| `json` | `LicenseFinder::JsonReport` | Machine consumption |
| `xml` | `LicenseFinder::XmlReport` | Generic XML |
| `junit` | `LicenseFinder::JunitReport` | Pipe into CI test reporters |
| `diff` | `LicenseFinder::DiffReport` | Compares two scans |

## Adding a new report format

1. Create `lib/license_finder/reports/my_report.rb`:

   ```ruby
   module LicenseFinder
     class MyReport < Report
       def to_s
         dependencies.map { |d| "#{d.name}|#{d.version}|#{d.licenses.first}" }.join("\n")
       end
     end
   end
   ```

2. Register the format in [`lib/license_finder/cli/base.rb`](../lib/license_finder/cli/base.rb)
   (the `--format` option) and in
   [`lib/license_finder/report.rb`](../lib/license_finder/report.rb)
   (the format -> class mapping).

3. Add a spec under `spec/lib/license_finder/reports/`.

## Custom ERB templates

For one-off reports without writing a class, use the existing
`erb_report` example: see
[`examples/custom_erb_template.rb`](../examples/custom_erb_template.rb).
