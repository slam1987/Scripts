# Quiz Generator & Quiz Marker

This project contains 2 separate scripts, one to generate the quiz, and the
other to automatically mark the quiz based on an answer key and unique quiz
identifier number.

The questions generated are based off a specified CSV file containing the
question, choices, and answer key.

Each quiz generated will be output to a specified .txt file with a unique "QID" identification number for the quiz marker.

After completing the quiz, save the file and execute `quiz_marker.py` to
automatically mark the quiz using each question's answer key.

CSV example file not included at the moment. I will add this on a later day.

**NOTE:** The purpose of this project is to gain a working knowledge of
combining spreadsheet data with Python. Also a great tool to use when studying
for a quiz or exam!
