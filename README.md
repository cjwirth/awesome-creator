awesome-creator
===============

The tool and data used to generate [cjwirth/awesome-ios-ui][repo].

This isn't necessarily meant to be flexible or reusable. It's just a simple way to manage the repo data in JSON format without having to deal with the resulting HTML or Markdown. Plus I can easily change the format :D

## Use

1. Open `awesome-creator.xcodeproj` and build the `awesome-creator` executable. 
1. Open the directory that the executable was created in. (Right-click the "awesome-creator" under Products in Xcode, and select "Show in Finder")
1. Make sure `LICENSES.md`, `TEMPLATE.md`, and the `data` directory were copied into the same directory as the `awesome-creator` executable.
1. Run `./awesome-creator`
1. Check out the resulting `output` directory should be the same as the [cjwirth/awesome-ios-ui][repo] minus the `assets` folder. 

My `output` folder is actually the real [cjwirth/awesome-ios-ui][repo] repo. So this the preferred way to contribute (and probably the easiest too!)

## Author

Caesar Wirth - cjwirth@gmail.com

<a href="http://www.twitter.com/cjwirth">
<img src="https://g.twimg.com/Twitter_logo_blue.png" width="50px" alt="@cjwirth on Twitter">
@cjwirth
</a>

## License

`awesome-creator` is released under the MIT License. See [LICENSE.md](./LICENSE.md) for details.


[repo]: https://github.com/cjwirth/awesome-ios-ui

