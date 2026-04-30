# Licenses

The license catalogue lives in
[`lib/license_finder/license/definitions.rb`](../lib/license_finder/license/definitions.rb)
along with helper matchers in `lib/license_finder/license/`.

## How license detection works

For each `Package`, `licensefinder` tries (in order):

1. **License declared by the package manager.** Most package managers
   surface a `license` field in their metadata; the relevant
   `*Package` class passes this through.
2. **License files inside the installed package.** Files matching
   `LICENSE*`, `COPYING*`, etc. are read and matched against known
   license texts via
   [`package_utils/license_files.rb`](../lib/license_finder/package_utils/license_files.rb).
3. **NOTICE files** are scanned for additional clues.
4. **Fallback to `unknown`** if nothing matches.

## Adding a new license

1. Open
   [`lib/license_finder/license/definitions.rb`](../lib/license_finder/license/definitions.rb).
2. Add a new `License.new(...)` block. At minimum supply:
   - `short_name` (the canonical name, e.g. `MIT`)
   - `pretty_name` (display name)
   - `other_names` (aliases / SPDX id)
   - One or more matchers (text matcher, header matcher, etc.)
3. Add a corresponding spec in `spec/lib/license_finder/license/`.

## Matchers

Located in `lib/license_finder/license/matcher.rb` and friends:

* `Matcher::Text` — full text match (whitespace-normalised)
* `Matcher::Header` — first-paragraph regex
* `Matcher::AnyMatcher` — boolean OR over child matchers

The MIT license uses several matchers; it's a good example to copy.
