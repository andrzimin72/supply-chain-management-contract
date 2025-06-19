// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
pragma abicoder v2;

contract SimpleVoting {

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    WorkflowStatus public workflowStatus;
    address public administrator;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    uint private winningProposalId;

    // Custom Errors
    error NotAdministrator();
    error NotRegisteredVoter();
    error InvalidStage();
    error AlreadyRegistered();
    error AlreadyVoted();
    error InvalidProposal();

    modifier onlyAdministrator() {
        if (msg.sender != administrator) revert NotAdministrator();
        _;
    }

    modifier onlyRegisteredVoter() {
        if (!voters[msg.sender].isRegistered) revert NotRegisteredVoter();
        _;
    }

    modifier onlyDuringVotersRegistration() {
        if (workflowStatus != WorkflowStatus.RegisteringVoters) revert InvalidStage();
        _;
    }

    modifier onlyDuringProposalsRegistration() {
        if (workflowStatus != WorkflowStatus.ProposalsRegistrationStarted) revert InvalidStage();
        _;
    }

    modifier onlyAfterProposalsRegistration() {
        if (workflowStatus != WorkflowStatus.ProposalsRegistrationEnded) revert InvalidStage();
        _;
    }

    modifier onlyDuringVotingSession() {
        if (workflowStatus != WorkflowStatus.VotingSessionStarted) revert InvalidStage();
        _;
    }

    modifier onlyAfterVotingSession() {
        if (workflowStatus != WorkflowStatus.VotingSessionEnded) revert InvalidStage();
        _;
    }

    modifier onlyAfterVotesTallied() {
        if (workflowStatus != WorkflowStatus.VotesTallied) revert InvalidStage();
        _;
    }

    event VoterRegisteredEvent(address indexed voterAddress);
    event ProposalsRegistrationStartedEvent();
    event ProposalsRegistrationEndedEvent();
    event ProposalRegisteredEvent(uint indexed proposalId);
    event VotingSessionStartedEvent();
    event VotingSessionEndedEvent();
    event VotedEvent(address indexed voter, uint indexed proposalId);
    event VotesTalliedEvent();
    event WorkflowStatusChangeEvent(WorkflowStatus previousStatus, WorkflowStatus newStatus);

    constructor() {
        administrator = msg.sender;
        workflowStatus = WorkflowStatus.RegisteringVoters;
    }

    function registerVoter(address _voterAddress)
        public
        onlyAdministrator
        onlyDuringVotersRegistration
    {
        if (voters[_voterAddress].isRegistered) revert AlreadyRegistered();

        voters[_voterAddress] = Voter({
            isRegistered: true,
            hasVoted: false,
            votedProposalId: 0
        });

        emit VoterRegisteredEvent(_voterAddress);
    }

    function startProposalsRegistration()
        public
        onlyAdministrator
        onlyDuringVotersRegistration
    {
        workflowStatus = WorkflowStatus.ProposalsRegistrationStarted;
        emit ProposalsRegistrationStartedEvent();
        emit WorkflowStatusChangeEvent(WorkflowStatus.RegisteringVoters, workflowStatus);
    }

    function endProposalsRegistration()
        public
        onlyAdministrator
        onlyDuringProposalsRegistration
    {
        workflowStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit ProposalsRegistrationEndedEvent();
        emit WorkflowStatusChangeEvent(WorkflowStatus.ProposalsRegistrationStarted, workflowStatus);
    }

    function registerProposal(string memory proposalDescription)
        public
        onlyRegisteredVoter
        onlyDuringProposalsRegistration
    {
        proposals.push(Proposal({
            description: proposalDescription,
            voteCount: 0
        }));

        emit ProposalRegisteredEvent(proposals.length - 1);
    }

    function getProposalsNumber() public view returns (uint) {
        return proposals.length;
    }

    function getProposalDescription(uint index) public view returns (string memory) {
        return proposals[index].description;
    }

    function startVotingSession()
        public
        onlyAdministrator
        onlyAfterProposalsRegistration
    {
        workflowStatus = WorkflowStatus.VotingSessionStarted;
        emit VotingSessionStartedEvent();
        emit WorkflowStatusChangeEvent(WorkflowStatus.ProposalsRegistrationEnded, workflowStatus);
    }

    function endVotingSession()
        public
        onlyAdministrator
        onlyDuringVotingSession
    {
        workflowStatus = WorkflowStatus.VotingSessionEnded;
        emit VotingSessionEndedEvent();
        emit WorkflowStatusChangeEvent(WorkflowStatus.VotingSessionStarted, workflowStatus);
    }

    function vote(uint proposalId)
        public
        onlyRegisteredVoter
        onlyDuringVotingSession
    {
        if (voters[msg.sender].hasVoted) revert AlreadyVoted();
        if (proposalId >= proposals.length) revert InvalidProposal();

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = proposalId;
        proposals[proposalId].voteCount += 1;

        emit VotedEvent(msg.sender, proposalId);
    }

    function tallyVotes()
        public
        onlyAdministrator
        onlyAfterVotingSession
    {
        uint winningVoteCount = 0;
        uint winningProposalIndex = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalIndex = i;
            }
        }

        winningProposalId = winningProposalIndex;
        workflowStatus = WorkflowStatus.VotesTallied;

        emit VotesTalliedEvent();
        emit WorkflowStatusChangeEvent(WorkflowStatus.VotingSessionEnded, workflowStatus);
    }

    function getWinningProposalId()
        public
        view
        onlyAfterVotesTallied
        returns (uint)
    {
        return winningProposalId;
    }

    function getWinningProposalDescription()
        public
        view
        onlyAfterVotesTallied
        returns (string memory)
    {
        return proposals[winningProposalId].description;
    }

    function getWinningProposalVoteCounts()
        public
        view
        onlyAfterVotesTallied
        returns (uint)
    {
        return proposals[winningProposalId].voteCount;
    }

    function isRegisteredVoter(address _voterAddress) public view returns (bool) {
        return voters[_voterAddress].isRegistered;
    }

    function isAdministrator(address _address) public view returns (bool) {
        return _address == administrator;
    }

    function getWorkflowStatus() public view returns (WorkflowStatus) {
        return workflowStatus;
    }
}