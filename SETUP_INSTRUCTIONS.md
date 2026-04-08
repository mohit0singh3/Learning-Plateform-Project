# Maven Build Setup Instructions

## Issue
Maven (`mvn`) command is not found in your system PATH.

## Solutions

### Option 1: Install Maven (Recommended)

1. **Download Maven**
   - Visit: https://maven.apache.org/download.cgi
   - Download: `apache-maven-3.9.x-bin.zip`

2. **Install Maven**
   - Extract to: `C:\Program Files\Apache\maven`
   - Add to PATH: `C:\Program Files\Apache\maven\bin`

3. **Verify Installation**
   ```powershell
   mvn -version
   ```

### Option 2: Use Maven Wrapper (If Available)

If the project has Maven Wrapper:
```powershell
cd backend
.\mvnw.cmd clean install
```

### Option 3: Use IDE

- **IntelliJ IDEA**: Right-click `pom.xml` → Maven → Reload Project, then Build
- **Eclipse**: Right-click project → Run As → Maven install
- **VS Code**: Install Maven extension, then use Command Palette → Maven: Clean Install

### Option 4: Check Java Installation

Maven requires Java:
```powershell
java -version
```

If Java is not installed:
- Download JDK 17 from: https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html
- Install and add to PATH

## Quick Setup Script

After installing Maven, run:
```powershell
cd backend
mvn clean install
```

## Expected Output

If successful, you should see:
```
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

## Troubleshooting

1. **Maven not found**: Add Maven bin directory to PATH
2. **Java not found**: Install JDK 17 or higher
3. **Build fails**: Check error messages, verify database connection settings

## Alternative: Use Docker

If Maven setup is complex, use Docker:
```powershell
docker-compose up -d
```

This will build and run everything automatically.
