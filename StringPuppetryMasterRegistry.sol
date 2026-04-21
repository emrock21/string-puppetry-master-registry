// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract StringPuppetryMasterRegistry {

    struct PuppetryStyle {
        string region;               // Fujian, Zhejiang, Guangdong, Sichuan, etc.
        string lineageOrWorkshop;    // real family, troupe, or workshop
        string styleName;            // Fujian String Puppetry, Cantonese Marionettes, etc.
        string materials;            // wood type, fabrics, strings, pigments
        string manipulationTechnique; // string system, articulation, movement style
        string performanceTraits;    // music, dialect, themes, staging
        string uniqueness;           // what makes this school culturally distinct
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    struct StyleInput {
        string region;
        string lineageOrWorkshop;
        string styleName;
        string materials;
        string manipulationTechnique;
        string performanceTraits;
        string uniqueness;
    }

    PuppetryStyle[] public styles;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event StyleRecorded(
        uint256 indexed id,
        string styleName,
        string lineageOrWorkshop,
        address indexed creator
    );

    event StyleVoted(
        uint256 indexed id,
        bool like,
        uint256 likes,
        uint256 dislikes
    );

    constructor() {
        styles.push(
            PuppetryStyle({
                region: "China",
                lineageOrWorkshop: "ExampleWorkshop",
                styleName: "Example Style (replace with real entries)",
                materials: "example materials",
                manipulationTechnique: "example technique",
                performanceTraits: "example traits",
                uniqueness: "example uniqueness",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordStyle(StyleInput calldata s) external {
        styles.push(
            PuppetryStyle({
                region: s.region,
                lineageOrWorkshop: s.lineageOrWorkshop,
                styleName: s.styleName,
                materials: s.materials,
                manipulationTechnique: s.manipulationTechnique,
                performanceTraits: s.performanceTraits,
                uniqueness: s.uniqueness,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit StyleRecorded(
            styles.length - 1,
            s.styleName,
            s.lineageOrWorkshop,
            msg.sender
        );
    }

    function voteStyle(uint256 id, bool like) external {
        require(id < styles.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;

        PuppetryStyle storage p = styles[id];

        if (like) {
            p.likes += 1;
        } else {
            p.dislikes += 1;
        }

        emit StyleVoted(id, like, p.likes, p.dislikes);
    }

    function totalStyles() external view returns (uint256) {
        return styles.length;
    }
}
