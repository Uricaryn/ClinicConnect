Clinic Connect - Medical CRM Application
Clinic Connect is a comprehensive Medical Customer Relationship Management (CRM) system designed to streamline operations within medical facilities. The application manages patient information, procedures, appointments, payments, and more, integrating various functionalities to ensure efficient healthcare management.

Note: This project is currently under active development. UI features will be fully implemented, and ongoing changes are expected.

Table of Contents
About the Project
Technologies Used
Features
Getting Started
Prerequisites
Installation
Running the Application
API Documentation
Contributing
Known Issues
Roadmap
License
Contact
About the Project
Clinic Connect is designed to assist medical professionals in managing the day-to-day operations of various clinics and hospitals. It provides tools for tracking patient appointments, managing medical procedures, updating patient records, and handling payments. The goal is to improve patient care, reduce administrative workload, and enhance the overall efficiency of medical facilities.

Technologies Used
Backend: ASP.NET Core 6, Entity Framework Core, SQL Server, AutoMapper, Identity for user authentication and authorization
Frontend: On development with flutter right now
API Documentation: Swagger for API testing and documentation
Logging: Serilog for structured logging
Version Control: Git and GitHub for source code management
Other Tools: Docker (for future containerization support), NUnit and xUnit for unit testing
Features
Patient Management: Create, read, update, and delete patient records.
Procedure Management: Manage medical procedures and track the products used in each procedure.
Appointment Scheduling: Schedule and manage appointments with integrated reminders.
User Authentication: Secure login system with roles and permissions using ASP.NET Identity.
Payments: Track patient payments and manage financial transactions.
Product Tracking: Track product stocks and usage on procedures through StockTransaction and ProcedureProduct.
Cross-Platform Accessibility: Accessible via desktop and mobile applications developed using .NET MAUI.
Getting Started
Prerequisites
.NET 6 SDK or higher
Visual Studio 2022 or later
SQL Server or SQL Server Express
Node.js (for potential frontend builds)
Docker (optional, for running in a containerized environment)


Contributing
Contributions are welcome! Please follow these steps:

Fork the project.
Create your feature branch (git checkout -b feature/new-feature).
Commit your changes (git commit -m 'Add some feature').
Push to the branch (git push origin feature/new-feature).
Open a pull request.
Roadmap
Complete the implementation of the payment module.
Enhance the UI for a better user experience.
Implement Docker support for easy deployment.
Add support for multi-language interfaces.
Integration with third-party healthcare services (e.g., insurance providers).
License
This project is licensed under the MIT License. See the LICENSE file for more details.

Contact
Developer: Onur Anatça
Email: onuranatca@hotmail.com.tr
