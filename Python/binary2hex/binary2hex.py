class outputNum:
	binaryNumber = 'the binary number input by user'
	binaryFormat = 'the binary number divisible by 4'
	decimalNumber = 'the decimal number converted from binary'
	groupBinary = 'grouped binary numbers into segments'
	groupDecimal = 'segment converted to decimals'
	hexNumber = 'calculated hexidecimal number'

	def __init__(self, var1):
		self.binaryNumber = var1

	def binaryOutput(self):
		return self.binaryNumber

	def decimalOutput(self):
		prevsum = 0
		totalsum = 0
		variable = self.binaryNumber
		for i in variable:
			totalsum = (2 * int(prevsum) + int(i))
			prevsum = totalsum
		self.decimalNumber = totalsum
		return self.decimalNumber

	def segmentOutput(self):
		variable = self.binaryNumber
		while len(variable) % 4 != 0:
			variable = (str(0) + (str(variable)))
		self.binaryFormat = variable
		return self.binaryFormat

	def groupedBinaryOutput(self):
		outputNum.segmentOutput(self)
		intMod = self.binaryFormat
		modifier = [intMod[x:x + 4] for x in range(0, len(intMod), 4)]
		self.groupBinary = modifier
		return self.groupBinary

	def groupedDecimalOutput(self):
		outputNum.groupedBinaryOutput(self)
		result = []
		count = 0
		variable = self.groupBinary
		for x in variable:
			prevsum = 0
			totalsum = 0
			for i in variable[count]:
				totalsum = (2 * int(prevsum) + int(i))
				prevsum = totalsum
			count = count + 1
			result.append(totalsum)
		self.groupDecimal = result
		return result

	def hexOutput(self):
		outputNum.groupedDecimalOutput(self)
		variable = self.groupDecimal
		result = []
		hex_chart = ["A", "B", "C", "D", "E", "F"]
		for x in variable:
			if x >= 10:
				modifier = (x - 10)
				totalsum = hex_chart[modifier]
			else:
				totalsum = x
			result.append(totalsum)
		result = str(result)
		result = result.replace("[", "").replace("]", "").replace(",","").replace(" ","").replace("'","")
		self.hexNumber = result
		return result

while True:
	try:
		inputRaw = input('Enter a binary number: ')
		inputRaw = inputRaw.replace(' ','')
		inputRef = outputNum(inputRaw)

		print ('Binary input converted to decimal is:', inputRef.decimalOutput(),\
			'\nBinary input after format is:', inputRef.segmentOutput(),\
			'\nBinary numbers grouped:', inputRef.groupedBinaryOutput(),\
			'\nBinary segments converted to decimals:', inputRef.groupedDecimalOutput(),\
			'\nBinary number conversion to hexidecimal:', inputRef.hexOutput())
		break

	except IndexError:
		print ("""
ERROR: Input only accepts 0's and 1's
			""")
		continue

	except ValueError:
		print ("""
ERROR: Input only accepts 0's and 1's
			""")
		continue
