-- =====================================================
-- Sample Data Insertion Script
-- =====================================================
-- This script inserts sample data for testing and development
-- =====================================================

USE codesphere_db;

-- =====================================================
-- Insert Sample Users
-- =====================================================
INSERT INTO users (username, email, password_hash, full_name, role, is_email_verified) VALUES
('john_doe', 'john.doe@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'John Doe', 'STUDENT', TRUE),
('jane_smith', 'jane.smith@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jane Smith', 'STUDENT', TRUE),
('prof_java', 'prof.java@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Professor Java', 'INSTRUCTOR', TRUE),
('admin_user', 'admin@codesphere.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'System Admin', 'ADMIN', TRUE);

-- Note: Password hash above is for 'password123' (BCrypt)

-- =====================================================
-- Insert Sample Learning Topics
-- =====================================================
INSERT INTO learning_topics (title, description, category, difficulty_level, order_index, estimated_time) VALUES
('Object-Oriented Programming Basics', 'Learn about classes, objects, and basic OOP concepts in Java', 'OOPs', 'BEGINNER', 1, 60),
('Inheritance and Polymorphism', 'Understanding inheritance, method overriding, and polymorphism in Java', 'OOPs', 'INTERMEDIATE', 2, 90),
('Encapsulation and Abstraction', 'Learn about data hiding, access modifiers, and abstract classes', 'OOPs', 'INTERMEDIATE', 3, 75),
('Java Collections Framework', 'Working with ArrayList, HashMap, HashSet, and other collections', 'Collections', 'BEGINNER', 1, 120),
('Advanced Collections', 'Understanding TreeMap, LinkedHashMap, and custom comparators', 'Collections', 'INTERMEDIATE', 2, 90),
('Data Structures - Arrays and Lists', 'Understanding arrays, ArrayList, and LinkedList in Java', 'DSA', 'BEGINNER', 1, 90),
('Data Structures - Stacks and Queues', 'Implementation and usage of stacks and queues', 'DSA', 'BEGINNER', 2, 60),
('Data Structures - Trees', 'Binary trees, BST, and tree traversal algorithms', 'DSA', 'INTERMEDIATE', 3, 120),
('Data Structures - Graphs', 'Graph representation and traversal algorithms', 'DSA', 'ADVANCED', 4, 150),
('Exception Handling', 'Try-catch blocks, custom exceptions, and exception best practices', 'Java Basics', 'BEGINNER', 1, 45),
('Multithreading Basics', 'Creating threads, synchronization, and thread safety', 'Concurrency', 'INTERMEDIATE', 1, 120),
('Streams and Lambda Expressions', 'Functional programming in Java using streams and lambdas', 'Java Advanced', 'INTERMEDIATE', 1, 90);

-- =====================================================
-- Insert Sample Exercises
-- =====================================================

-- Exercise 1: Create Student Class
INSERT INTO exercises (topic_id, title, description, starter_code, solution_code, difficulty, points, order_index, test_cases) VALUES
(1, 'Create a Student Class', 
'Create a Student class with the following:
- Private attributes: name (String) and age (int)
- Public getter and setter methods for both attributes
- A constructor that takes name and age as parameters',
'public class Student {\n    // Add your code here\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        // Test your Student class here\n    }\n}',
'public class Student {\n    private String name;\n    private int age;\n    \n    public Student(String name, int age) {\n        this.name = name;\n        this.age = age;\n    }\n    \n    public String getName() {\n        return name;\n    }\n    \n    public void setName(String name) {\n        this.name = name;\n    }\n    \n    public int getAge() {\n        return age;\n    }\n    \n    public void setAge(int age) {\n        this.age = age;\n    }\n}',
'BEGINNER', 10, 1,
'[{"input": "Student s = new Student(\"John\", 20);", "expected": "s.getName() == \"John\" && s.getAge() == 20"}]');

-- Exercise 2: Use ArrayList
INSERT INTO exercises (topic_id, title, description, starter_code, solution_code, difficulty, points, order_index, hints) VALUES
(4, 'Use ArrayList', 
'Create an ArrayList of Strings, add at least 3 elements, and print all elements using a for-each loop.',
'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        // Your code here\n    }\n}',
'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> list = new ArrayList<>();\n        list.add(\"Hello\");\n        list.add(\"World\");\n        list.add(\"Java\");\n        \n        for(String item : list) {\n            System.out.println(item);\n        }\n    }\n}',
'BEGINNER', 10, 1,
'["Use ArrayList<String> to create a list", "Use add() method to add elements", "Use enhanced for loop to iterate"]');

-- Exercise 3: Inheritance
INSERT INTO exercises (topic_id, title, description, starter_code, solution_code, difficulty, points, order_index) VALUES
(2, 'Implement Inheritance', 
'Create a base class Animal with a method makeSound(). Create a Dog class that extends Animal and overrides makeSound() to print "Woof!".',
'class Animal {\n    // Your code here\n}\n\nclass Dog extends Animal {\n    // Your code here\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        Dog dog = new Dog();\n        dog.makeSound();\n    }\n}',
'class Animal {\n    public void makeSound() {\n        System.out.println(\"Some sound\");\n    }\n}\n\nclass Dog extends Animal {\n    @Override\n    public void makeSound() {\n        System.out.println(\"Woof!\");\n    }\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        Dog dog = new Dog();\n        dog.makeSound();\n    }\n}',
'INTERMEDIATE', 15, 1);

-- Exercise 4: HashMap
INSERT INTO exercises (topic_id, title, description, starter_code, solution_code, difficulty, points, order_index) VALUES
(4, 'Use HashMap', 
'Create a HashMap that maps student names (String) to their grades (Integer). Add at least 3 entries and print all key-value pairs.',
'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        // Your code here\n    }\n}',
'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        HashMap<String, Integer> grades = new HashMap<>();\n        grades.put(\"Alice\", 95);\n        grades.put(\"Bob\", 87);\n        grades.put(\"Charlie\", 92);\n        \n        for(String name : grades.keySet()) {\n            System.out.println(name + \": \" + grades.get(name));\n        }\n    }\n}',
'BEGINNER', 10, 2);

-- Exercise 5: Exception Handling
INSERT INTO exercises (topic_id, title, description, starter_code, solution_code, difficulty, points, order_index) VALUES
(10, 'Handle Exceptions', 
'Write a method divide(int a, int b) that divides two numbers. Handle the ArithmeticException when dividing by zero and print an appropriate message.',
'public class Main {\n    public static void main(String[] args) {\n        divide(10, 2);\n        divide(10, 0);\n    }\n    \n    // Your code here\n}',
'public class Main {\n    public static void main(String[] args) {\n        divide(10, 2);\n        divide(10, 0);\n    }\n    \n    public static void divide(int a, int b) {\n        try {\n            int result = a / b;\n            System.out.println(\"Result: \" + result);\n        } catch (ArithmeticException e) {\n            System.out.println(\"Error: Cannot divide by zero!\");\n        }\n    }\n}',
'BEGINNER', 10, 1);

-- =====================================================
-- Insert Sample Projects
-- =====================================================
INSERT INTO projects (name, description, owner_id, language, is_public) VALUES
('My First Java Project', 'Learning Java basics', 1, 'java', FALSE),
('Data Structures Practice', 'Practicing DSA concepts', 1, 'java', TRUE),
('OOP Concepts Demo', 'Demonstrating OOP principles', 2, 'java', FALSE),
('Collections Framework', 'Working with Java Collections', 2, 'java', TRUE);

-- =====================================================
-- Insert Sample Project Collaborators
-- =====================================================
INSERT INTO project_collaborators (project_id, user_id, role) VALUES
(1, 1, 'OWNER'),
(2, 1, 'OWNER'),
(2, 2, 'EDITOR'),
(3, 2, 'OWNER'),
(4, 2, 'OWNER'),
(4, 1, 'VIEWER');

-- =====================================================
-- Insert Sample Code Files
-- =====================================================
INSERT INTO code_files (project_id, filename, file_path, content, language, last_modified_by) VALUES
(1, 'Main.java', '/src/Main.java', 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}', 'java', 1),
(1, 'Student.java', '/src/Student.java', 'public class Student {\n    private String name;\n    private int age;\n    \n    // Getters and setters\n}', 'java', 1),
(2, 'LinkedListDemo.java', '/src/LinkedListDemo.java', 'import java.util.LinkedList;\n\npublic class LinkedListDemo {\n    public static void main(String[] args) {\n        LinkedList<String> list = new LinkedList<>();\n        // Add your code here\n    }\n}', 'java', 1),
(3, 'Animal.java', '/src/Animal.java', 'public class Animal {\n    public void makeSound() {\n        System.out.println("Some sound");\n    }\n}', 'java', 2),
(3, 'Dog.java', '/src/Dog.java', 'public class Dog extends Animal {\n    @Override\n    public void makeSound() {\n        System.out.println("Woof!");\n    }\n}', 'java', 2);

-- =====================================================
-- Insert Sample User Progress
-- =====================================================
INSERT INTO user_progress (user_id, exercise_id, status, is_correct, attempts, score) VALUES
(1, 1, 'COMPLETED', TRUE, 1, 10),
(1, 2, 'COMPLETED', TRUE, 2, 10),
(1, 4, 'IN_PROGRESS', NULL, 1, 0),
(2, 1, 'COMPLETED', TRUE, 1, 10),
(2, 3, 'COMPLETED', TRUE, 1, 15);

-- =====================================================
-- END OF SAMPLE DATA
-- =====================================================
