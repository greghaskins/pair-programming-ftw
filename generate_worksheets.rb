#!/usr/bin/env ruby

Rounds = ['X', 'Y', 'Z']
StoriesPerRound = 6

Consonants = ['b', 'd', 'p', 'q']
Vowels = [ 'a',]
WordsPerLine = 12
NumberOfLines = 3

require 'erb'

# This script generates HTML for the worksheet and answer sheets.

def run!
  words = generate_words
  backlog = words.sample(StoriesPerRound)

  blank_worksheets = {}
  answer_sheets = {}

  match_counts = {}
  round_totals = {}

  Rounds.each do |round|
    loop do
      puzzle = make_puzzle(words)
      round_totals[round] = 0

      puts "Generating sheets for round #{round}..."

      backlog.each_with_index do |backlog_item, index_in_backlog|
        story_id = "#{round}#{index_in_backlog + 1}"

        #puts "  Creating blank worksheet for story #{story_id}..."
        blank_worksheet = make_worksheet_page(puzzle, story_id, backlog_item)
        blank_worksheets[story_id] = blank_worksheet

        #puts "  Creating answer sheet for story #{story_id}..."
        answer_sheet = make_answer_sheet(puzzle, story_id, backlog_item)
        answer_sheets[story_id] = answer_sheet.content

        match_count = answer_sheet.match_count
        match_counts[[round, backlog_item]] = match_count
        round_totals[round] += match_count
      end

      desired_total = round_totals[Rounds[0]]

      break if round_totals[round] == desired_total
      puts "...trying again. Shooting for #{desired_total} total..."
    end
  end

  puts "Saving HTML versions..."
  blank_worksheets.keys.each do |story_id|
    IO.write("blank_worksheet_#{story_id}.html", blank_worksheets[story_id])
    IO.write("answer_sheet_#{story_id}.html", answer_sheets[story_id])
  end

  match_counts_sheet = make_matchcount_page(backlog, match_counts)
  IO.write('quality_check_sheet.html', match_counts_sheet)

  puts "Round totals: #{round_totals}"

  puts "Converting to PDF..."
  input_files = "blank_worksheet_*.html answer_sheet_*.html quality_check_sheet.html"
  %x(wkhtmltopdf --page-size Letter #{input_files} materials.pdf)

  puts "Cleaning up temp files..."
  %x(rm answer_sheet_*.html blank_worksheet_*.html quality_check_sheet.html)
end

def generate_words
  syllables = get_combinations_of(Consonants, Vowels)
  words = get_combinations_of(syllables, syllables)
end

def get_combinations_of(list1, list2)
  combinations = []
  list1.each do |item1|
    list2.each do |item2|
      combinations << "#{item1}#{item2}"
    end
  end
  combinations
end

def make_puzzle(words)
  puzzle = ""
  NumberOfLines.times do
    WordsPerLine.times do
      puzzle += words.sample
    end
    puzzle += "\n"
  end
  puzzle.strip
end

def make_worksheet_page(puzzle, story_id, search_pattern)
  make_puzzle_page(puzzle, story_id, search_pattern)
end

AnswerSheet = Struct.new(:content, :match_count)

def make_answer_sheet(puzzle, story_id, search_pattern)
  puzzle_highlighted = highlight_substrings(puzzle, search_pattern)
  content = make_puzzle_page(puzzle_highlighted, "Answers for #{story_id}",
                             search_pattern)
  match_count = puzzle.scan(search_pattern).length
  AnswerSheet.new(content, match_count)
end

def make_puzzle_page(puzzle_html, story_id, search_pattern)
  html_page(story_id, %Q$
    	<header>
            <h1>#{story_id}</h1>
            <p>Searching for:</p>
            <h2><code>#{search_pattern}</code></h2>
        </header>
    	<pre><code>#{puzzle_html}</code></pre>
      <footer>
        <pre>
      QA defects found:#{"&nbsp;" * 6}

Customer defects found:#{"&nbsp;" * 6}
        </pre>
      </footer>$)
end

def highlight_substrings(text, search_pattern)
  highlighted_pattern = %{<span class="match">#{search_pattern}</span>}
  text.gsub(search_pattern, highlighted_pattern)
end

def make_matchcount_page(backlog, match_counts)
  renderer = ERB.new(html_page("Quality Check", %Q$
    <header>
      <h1>Quality Check</h1>
    </header>
    <h2>Match counts:</h2>
    <table>
      <tr>
      <td colspan="2"></td>
      <% Rounds.each do |round| %>
        <th><%= round %></th>
      <% end %>
      </tr>

      <% backlog.each_with_index do |backlog_item, index| %>
        <tr>
          <th><%= index + 1 %></th>
          <th><%= backlog_item %></th>
          <% Rounds.each do |round| %>
            <td><%= match_counts[[round, backlog_item]] %></td>
          <% end %>
        </tr>
      <% end %>
    </table>$))
  renderer.result(binding)
end

def html_page(title, body_content)
  %Q$<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>#{title}</title>
        <meta name="viewport" content="width=device-width">
        <style>
            @font-face {
                font-family: 'Menlo';
                font-weight: normal;
                font-style: normal;
                src: url('file:///System/Library/Fonts/Menlo.ttc') format("truetype")
            }
            body, code, pre {
                font-family: Menlo, monospace;
            }
            body {
                text-align: center;
                font-size: 20px;
            }
            header {
                margin-bottom: 5em;
            }
            footer {
                margin-top: 4em;
            }
            .match {
                background: #333;
                padding: 4px 0;
                color: white;
            }
            table {
              margin: 0 auto;
              border-collapse: collapse;
            }
            td, th {
              padding: 0.5em;
              border: 1px solid #ccc;
            }
        </style>
    </head>
    <body>
    #{body_content}
    </body>
</html>
$
end

if __FILE__ == $0
    run!
end
