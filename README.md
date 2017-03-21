# Pair Programming, ftw! A Simulation Workshop

At first glance, many people think pair programming is ridiculous. Why pay two people for a single job? We know better, of course, but it's often still not easy to convince skeptics.

This is a hands-on, non-technical workshop that proves the true value of pair programming: *speed*. Even if you ignore all the (numerous) other benefits of pairing, it's pretty hard to argue with higher team throughput.

Workshop participants can be any mix of developers, testers, managers, business analysts, marketing executives, HR – anybody. No technical skills are required.

## Running the Workshop

Most of what you need to run the workshop can be found in [materials.pdf](materials.pdf). That includes:

- Facilitator script and setup instructions
- Participant worksheets
- Supplementary slide deck with visual aids

## Tweaking the Content

The worksheets and instructions are generated from an automated script because I'm a lazy programmer and wanted to play with Ruby.

You'll need:

- [Ruby](https://www.ruby-lang.org/)
- [wkhtmltopdf](http://wkhtmltopdf.org/)

Then, just edit and run the `generate_materials.rb` script to regenerate the materials. Have fun with it.

Some of the process is somewhat manual because I wanted to tweak formatting and such and haven't gotten around to finding a good way to automate that.
