# Business Requirements

1. Mark all the occurrences/matches of the indicated word on the worksheet.
2. If two matches overlap, only mark the one on the left.
3. Each missing match counts as one defect.
4. Each incorrect "match" counts as one defect.

# Roles and Rules

- Only **developers** have the tools _(pencils)_ to make and erase marks. Their specialized skills also make developers the only people who understand the implementation details _(nobody can help them do the actual work)_.
- **QA** is capable of high-level validation _(the expected number of matches)_, but they don't have the tools or skills to make any fixes. They can tell the developers how many defects were found, and that's all. (Just look too see if the count matches.)
- The **customer** can always tell if the completed product is acceptable _(they use an answer sheet)_. Customers are impatient, however, so they can _only tell the team if the end result is good or bad_.
- **Defects are top priority** and need to be fixed immediately. Interrupt other work if necessary.
