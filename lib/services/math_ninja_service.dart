import 'dart:math';

class MathNinjaService {
  //? Function to generate 2 random numbers based on difficulty
  List<int> generateNumbers(int difficulty) {
    Random r = Random();
    int num1;
    int num2;

    switch (difficulty) {
      case 1:
        num1 = r.nextInt(5) + 0;
        num2 = r.nextInt(5) + 0;
        break;

      case 2:
        num1 = r.nextInt(10) + 5;
        num2 = r.nextInt(10) + 5;
        break;

      case 3:
        num1 = r.nextInt(20) + 10;
        num2 = r.nextInt(20) + 10;
        break;
    }

    return [num1, num2];
  }

  //? Main function that generates question and answers
  dynamic generateQuestionAndAnswer(
      List<bool> operations, int difficulty, int numberofquestions) {
    Random r = Random();
    bool addition;
    bool subtraction;
    bool multiplication;
    bool division;
    int answer;
    dynamic questionsAndAnswers = [];

    operations[0] == true ? addition = true : addition = false;
    operations[1] == true ? subtraction = true : subtraction = false;
    operations[2] == true ? multiplication = true : multiplication = false;
    operations[3] == true ? division = true : division = false;

    //* Cases for all possible true, false combos
    // false	false	false	false
    bool case1() =>
        addition == false &&
        subtraction == false &&
        multiplication == false &&
        division == false;
    // false	false	false	true
    bool case2() =>
        addition == false &&
        subtraction == false &&
        multiplication == false &&
        division == true;
    // false	false	true	false
    bool case3() =>
        addition == false &&
        subtraction == false &&
        multiplication == true &&
        division == false;
    // false	false	true	true
    bool case4() =>
        addition == false &&
        subtraction == false &&
        multiplication == true &&
        division == true;
    // false	true	false	false
    bool case5() =>
        addition == false &&
        subtraction == true &&
        multiplication == false &&
        division == false;
    // false	true	false	true
    bool case6() =>
        addition == false &&
        subtraction == true &&
        multiplication == false &&
        division == true;
    // false	true	true	false
    bool case7() =>
        addition == false &&
        subtraction == true &&
        multiplication == true &&
        division == false;
    // false	true	true	true
    bool case8() =>
        addition == false &&
        subtraction == true &&
        multiplication == true &&
        division == true;
    // true	false	false	false
    bool case9() =>
        addition == true &&
        subtraction == false &&
        multiplication == false &&
        division == false;
    // true	false	false	true
    bool case10() =>
        addition == true &&
        subtraction == false &&
        multiplication == false &&
        division == true;
    // true	false	true	false
    bool case11() =>
        addition == true &&
        subtraction == false &&
        multiplication == true &&
        division == false;
    // true	false	true	true
    bool case12() =>
        addition == true &&
        subtraction == false &&
        multiplication == true &&
        division == true;
    // true	true	false	false
    bool case13() =>
        addition == true &&
        subtraction == true &&
        multiplication == false &&
        division == false;
    // true	true	false	true
    bool case14() =>
        addition == true &&
        subtraction == true &&
        multiplication == false &&
        division == true;
    // true	true	true	false
    bool case15() =>
        addition == true &&
        subtraction == true &&
        multiplication == true &&
        division == false;
    // true	true	true	true
    bool case16() =>
        addition == true &&
        subtraction == true &&
        multiplication == true &&
        division == true;

    //? Loop runs n times to generate questions and answers
    for (int i = 0; i < numberofquestions; i++) {
      //* Generate Random Numbers
      List<int> numbers = generateNumbers(difficulty);
      //* Assigning values to num1, num2 from generateNumbers();
      int num1 = numbers[0];
      int num2 = numbers[1];

      //* Generate a random operation
      List<String> ops;
      String selectedOp;

      if (case1() == true) {
        ops = [''];
        selectedOp = '';
      } else if (case2() == true) {
        ops = ['/'];
        selectedOp = '/';
      } else if (case3() == true) {
        ops = ['x'];
        selectedOp = 'x';
      } else if (case4() == true) {
        ops = ['x', '/'];
        selectedOp = ops[r.nextInt(2)];
      } else if (case5() == true) {
        ops = ['-'];
        selectedOp = '-';
      } else if (case6() == true) {
        ops = ['-', '/'];
        selectedOp = ops[r.nextInt(r.nextInt(2))];
      } else if (case7() == true) {
        ops = ['-', 'x'];
        selectedOp = ops[r.nextInt(r.nextInt(2))];
      } else if (case8() == true) {
        ops = ['-', 'x', '/'];
        selectedOp = ops[r.nextInt(3)];
      } else if (case9() == true) {
        ops = ['+'];
        selectedOp = '+';
      } else if (case10() == true) {
        ops = ['+', '/'];
        selectedOp = ops[r.nextInt(2)];
      } else if (case11() == true) {
        ops = ['+', 'x'];
        selectedOp = ops[r.nextInt(2)];
      } else if (case12() == true) {
        ops = ['+', 'x', '/'];
        selectedOp = ops[r.nextInt(3)];
      } else if (case13() == true) {
        ops = ['+', '-'];
        selectedOp = ops[r.nextInt(2)];
      } else if (case14() == true) {
        ops = ['+', '-', '/'];
        selectedOp = ops[r.nextInt(3)];
      } else if (case15() == true) {
        ops = ['+', '-', 'x'];
        selectedOp = ops[r.nextInt(3)];
      } else if (case16() == true) {
        ops = ['+', '-', 'x', '/'];
        selectedOp = ops[r.nextInt(4)];
      }

      //x Generate answer
      switch (selectedOp) {
        case '+':
          answer = num1 + num2;
          break;
        case '-':
          answer = num1 - num2;
          break;
        case 'x':
          answer = num1 * num2;
          break;
        case '/':
          if (num2 == 0) {
            num2 = 1;
          }
          answer = (num1 ~/ num2).toInt();
          break;
      }
      questionsAndAnswers.add([num1, selectedOp, num2, answer]);
    }

    //* Return the question, operation and answers in a list
    return questionsAndAnswers;
  }
}
