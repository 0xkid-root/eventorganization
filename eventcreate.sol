//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract EventContract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCout;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId; //event ID, initial value is zero

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
        require(date>block.timestamp,"You can organize event for future date");
        require(ticketCount>0,"You can organize event only if u create more than 0 tickets");
        events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;

    }

    function buyTicket(uint id,uint quantity) external payable {
        require(events[id].date!=0,"This event does not exits");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity,"No enough Token");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"This event does not exits");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;

    }

}
