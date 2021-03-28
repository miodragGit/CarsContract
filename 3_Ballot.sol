pragma solidity ^0.8.1;


contract CarsContract {
    
     struct Car{
        uint carId;
        string color;
        address owner;
        bool registered;
    }
    
    Car[] public cars;
    mapping(uint => Car) public carsMapping;
    
    modifier onlyByOwner(address owner) {
      require(
         msg.sender == owner,
         "Sender is not owner of car."
      );
      _;
    }
    
    function createCar(string memory color) public{
        
        Car memory newCar = Car({
            carId: cars.length + 1,
            color: color,
            owner: msg.sender,
            registered: false
        });
        
        carsMapping[cars.length + 1] = newCar;
        
        cars.push(newCar);
    }
    
    function changeCarColor(string memory newColor, uint carId) 
        public payable onlyByOwner(carsMapping[carId].owner)
    {
        require(msg.value == 1 ether);
        carsMapping[carId].color = newColor;
        
        for (uint i = 0; i < cars.length; i++){
            if (cars[i].carId == carId){
                cars[i].color = newColor;
            }
        }
    }
    
    function registerCar(uint carId) 
        public payable onlyByOwner(carsMapping[carId].owner)
    {
        require(msg.value == 2 ether);
        if (!carsMapping[carId].registered){
            carsMapping[carId].registered = true;
            
            for (uint i = 0; i < cars.length; i++){
                if (cars[i].carId == carId){
                    cars[i].registered = true;
                }
            }
        }
    }
    
    function getCarOwner(uint carId) public view returns (address) {
        return carsMapping[carId].owner;
    }
    
    function getNumberOfCarsForOwner(address owner) public view returns (uint){
        uint count;
        
        for (uint i = 0; i < cars.length; i++){
            if (cars[i].owner == owner){
                count++;
            }
        } 
        
        return count;
    }
}