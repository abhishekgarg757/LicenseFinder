# Adding a Package Manager

Every supported ecosystem is a single Ruby class that subclasses
`LicenseFinder::PackageManager`. Adding one is a 4-step process.

## 1. Create the class

```ruby
# lib/license_finder/package_managers/my_pm.rb
module LicenseFinder
  class MyPm < PackageManager
    # Files whose presence in the project root activates this PM.
    def possible_package_paths
      [project_path.join('my-lockfile.json')]
    end

    # Return an array of LicenseFinder::Package objects.
    def current_packages
      JSON.parse(File.read(detected_package_path)).map do |dep|
        Package.new(
          dep['name'],
          dep['version'],
          spec_licenses: Array(dep['license']),
          homepage: dep['homepage']
        )
      end
    end

    # Optional: how to install dependencies on disk before scanning,
    # used by `--prepare`.
    def prepare_command
      'mypm install'
    end

    # Optional: command used by `rake check_dependencies` to verify the
    # tool is on PATH.
    def package_management_command
      'mypm'
    end
  end
end
```

## 2. Register it

Add the class to the scanner's list:

```ruby
# lib/license_finder/scanner.rb
PACKAGE_MANAGERS = [
  Bundler, Npm, ..., MyPm
]
```

## 3. Tests

* **Unit test** at `spec/lib/license_finder/package_managers/my_pm_spec.rb`.
  Use `fakefs` for filesystem operations and stub
  `LicenseFinder::SharedHelpers::Cmd.run` if you shell out.
* **Feature test** at
  `features/features/package_managers/my_pm_spec.rb` exercising a real
  fixture project at `features/fixtures/my_pm/`. Tag it with
  `:tool_required` if it shells out to a binary not always available.

## 4. Documentation + Docker

* Add a row to the *Supported project types* table in
  [`README.md`](../README.md).
* If the package manager needs a binary that isn't already installed,
  add a layer to the [`Dockerfile`](../Dockerfile).
* Add a CHANGELOG entry under the next *Unreleased* section.

## Existing examples

For inspiration look at:

* Simple lockfile parser: [`bundler.rb`](../lib/license_finder/package_managers/bundler.rb)
* Shells out to a CLI: [`npm.rb`](../lib/license_finder/package_managers/npm.rb)
* Walks an installed dependency tree on disk: [`maven.rb`](../lib/license_finder/package_managers/maven.rb)
