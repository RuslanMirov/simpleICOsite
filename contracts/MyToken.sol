pragma solidity ^0.4.2;

contract MyToken {
    string  public name = "My Token";
    string  public symbol = "MYT";
    string  public standard = "v1.0";
    uint256 public totalSupply;
/*Событие, которое должно возникать при любом перемещении монет. Т.е. его нужно создавать
внутри функций transfer и transferFrom в случае успешного перемещения монет.*/
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
/*Событие должно возникать при получении разрешения на снятие монет.
Фактически должно создаваться внутри функции approve.*/
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    //Возвращает количество монет принадлежащих _owner.
    // работает по принципу ключ => значение
    mapping(address => uint256) public balanceOf;
    //Возвращает сколько монет со своего счета разрешил снимать пользователь _owner пользователю _spender.
    mapping(address => mapping(address => uint256)) public allowance;

    //В конструкторе присваеваем все токены, на адрес создателя контракта
    // а так же записываем общее количество токенов в переменную totalSupply
    //Инициализация происходит в файле миграций
    function MyToken (uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }
    // Функция отправки
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        Transfer(msg.sender, _to, _value);

        return true;
    }
/*Разрешает пользователю _spender снимать с вашего счета
(точнее со счета вызвавшего функцию пользователя) средства не более чем _value.
На основе этого разрешения должна работать функция transferFrom.*/
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;
    }
/*Передает _ value монет от _from к _to. Пользователь должен иметь разрешение на перемещение
монеток между адресами, дабы любой желающий не смог управлять чужими кошельками.
Фактически эта функция позволяет вашему доверенному лицу распоряжаться определенным
объемом монеток на вашем счету.*/
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        Transfer(_from, _to, _value);

        return true;
    }
}
