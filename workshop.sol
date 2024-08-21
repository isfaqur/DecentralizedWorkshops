// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedWorkshops {
    struct Workshop {
        uint id;
        string title;
        string description;
        address organizer;
        uint256 date;
        uint256 capacity;
        uint256 enrolledCount;
        bool isActive;
    }

    uint public workshopCount;
    mapping(uint => Workshop) public workshops;

    function createWorkshop(string memory _title, string memory _description, uint256 _date, uint256 _capacity) public {
        workshopCount++;
        workshops[workshopCount] = Workshop(workshopCount, _title, _description, msg.sender, _date, _capacity, 0, true);
    }

    mapping(address => mapping(uint => bool)) public enrollments;

    function enrollInWorkshop(uint _workshopId) public {
        Workshop storage workshop = workshops[_workshopId];
        require(workshop.isActive, "Workshop is not active");
        require(workshop.enrolledCount < workshop.capacity, "Workshop is full");

        workshop.enrolledCount++;
        enrollments[msg.sender][_workshopId] = true;
    }

    mapping(address => mapping(uint => bool)) public attendance;

    function verifyAttendance(uint _workshopId) public {
        require(enrollments[msg.sender][_workshopId], "Not enrolled in the workshop");
        attendance[msg.sender][_workshopId] = true;
    }

    struct Certification {
        uint id;
        uint workshopId;
        address recipient;
        bool isIssued;
    }

    uint public certificationCount;
    mapping(uint => Certification) public certifications;

    function issueCertificate(uint _workshopId) public {
        require(attendance[msg.sender][_workshopId], "Attendance not verified");

        certificationCount++;
        certifications[certificationCount] = Certification(certificationCount, _workshopId, msg.sender, true);
    }
}
