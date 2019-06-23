import re
import csv


testname = input("Test Filename: ")
answername = input("Database Filename: ")
testname = testname + ".txt"
answername = answername + ".csv"


def txtcontents():  # read contents from txt
    file = open(testname, "r")
    read = file.read()
    file.close()
    return read


def fetchanswers():  # scrape user answers
    file = re.compile("Answer = \[([ABCDabcd])")
    results = file.findall(txtcontents())
    return results


def fetchident():  # identifier sequence
    file = open(testname, "r")
    read = file.readlines()
    readlist = read[0].strip("QID").strip(" ").strip("\n")
    result = readlist.split(":")
    file.close()
    return result


def csvdefine():  # answers from csv
    with open(answername, 'r') as csv_file:
        csv_reader = csv.reader(csv_file)
        rows = list(csv_reader)
        result = list(rows[26])
        return result


def answerkey():  # list of adapted answer key
    keylist = []
    for x in fetchident():
        keylist.append(csvdefine()[int(x)])
    return keylist


def automark():
    correct = []
    var = 0
    for x in fetchanswers():
        if x.upper() == answerkey()[var]:
            correct.append("Correct")
            var += 1
        else:
            correct.append("Incorrect")
            var += 1
    return correct


def scorecalc():
    points = 0
    for boolean in automark():
        if "Correct" in boolean:
            points += 1
    result = points / len(automark()) * 100
    result = round(result)
    return result


def append2text():  # append markings
    file = open(testname, "r")
    read = file.readlines()
    file.close()
    varname = testname.replace(".txt", "")
    varname = varname + "_result.txt"
    file = open(varname, "w+")
    counter = 0
    for match in read:
        if "Answer =" in match:
            file.write(match + automark()[counter] + ", " + answerkey()[counter] + " is the correct answer!")
            counter += 1
        elif "NAME =" in match:
            file.write(match + "Score: " + str(scorecalc()) + "%\n")
        else:
            file.write(match)
    file.close()
    print("Marking complete and output as", varname)


def debug():

    print(fetchanswers())
    print(fetchident())
    print(csvdefine())
    print(answerkey())
    print(automark())
    print(scorecalc())
    append2text()


debug()
