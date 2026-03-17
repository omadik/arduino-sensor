# ArduinoBridge.gd
extends Node

signal distance_changed(dist: float)  # Основной сигнал
signal connected(port: String)        # Успешное подключение
signal failed()                       # Не найден

var serial: GdSerial = null
var current_port: String = ""

func _ready() -> void:
	connect_to_arduino()

func connect_to_arduino() -> void:
	serial = GdSerial.new()
	if serial == null:
		print("Ошибка: GdSerial не создан! Проверь, включен ли аддон.")
		failed.emit()
		return

	var ports = serial.list_ports()
	print("Доступные порты: ", ports)

	var found = false
	for port_info in ports:
		var p: String = port_info["port_name"]
		print("Пробуем открыть: ", p)
		serial.set_port(p)
		serial.set_baud_rate(9600)
		if serial.open():
			print("Успешно открыт: ", p)
			current_port = p
			connected.emit(p)
			found = true
			break
		else:
			print("Не удалось открыть ", p)

	if not found:
		print("Arduino не найден на доступных портах!")
		failed.emit()

func _process(_delta: float) -> void:
	if serial == null or not serial.is_open():
		return

	while serial.bytes_available() > 0:
		var line: String = serial.readline().strip_edges()
		if line.is_valid_float():
			var dist: float = line.to_float()
			if dist > 0 and dist < 8190:  # Игнор ошибок (8190, 65535 и т.д.)
				distance_changed.emit(dist)

# Опционально: ручное чтение (если нужно в других местах)
func read_distance() -> float:
	if serial == null or not serial.is_open() or serial.bytes_available() == 0:
		return -1.0
	var line: String = serial.readline().strip_edges()
	if line.is_valid_float():
		var dist: float = line.to_float()
		if dist > 0 and dist < 8190:
			return dist
	return -1.0

func _exit_tree() -> void:
	if serial != null and serial.is_open():
		serial.close()
		print("Serial порт закрыт при выходе")
