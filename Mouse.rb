#==============================================================================
# ** Mouse Diamond
#------------------------------------------------------------------------------
# Autor: Valentine
#------------------------------------------------------------------------------
# Versão: 1.2
#==============================================================================

module Mouse_Configs
  # Índice no IconSet.png do ícone do cursor
  CURSOR_ICON = 147
  
  # Opacidade do cursor (de 0 a 255)
  CURSOR_OPACITY = 255
end

#==============================================================================
# ** Mouse
#==============================================================================
module Mouse
  class << self
    attr_reader   :x, :y
  end
  # Matriz dos botões
  @clicked = []
  @pressed = []
  @dbl_clicked = []
  @states = {}
  # Chave dos botões
  KEYS = {
    :Left => 1,
    :Right => 2,
    :Middle => 4
  }
  # Esconde o cursor original
  Win32API.new('user32', 'ShowCursor', 'i', 'i').call(0)
  # Win32 API
  ScreenToClient = Win32API.new('user32', 'ScreenToClient', 'lp', 'i')
  GetCursorPos = Win32API.new('user32', 'GetCursorPos', 'p', 'i')
  GetAsyncKeyState = Win32API.new('user32', 'GetAsyncKeyState', 'i', 'i')
  GetKeyState = Win32API.new('user32', 'GetKeyState', 'i', 'i')
  GetPrivateProfileStringA = Win32API.new('kernel32', 'GetPrivateProfileStringA', 'pppplp', 'l')
  FindWindowA = Win32API.new('user32', 'FindWindowA', 'pp', 'l')
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def self.init
    @cursor_sprite = Sprite_Cursor.new
    update
  end
  #--------------------------------------------------------------------------
  # * Obtenção da posição do cursor
  #--------------------------------------------------------------------------
  def self.cursor_pos
    pos = [0, 0].pack('ll')
    GetCursorPos.call(pos)
    ScreenToClient.call(HWND, pos)
    pos.unpack('ll')
  end
  #--------------------------------------------------------------------------
  # * Obtenção do identificador
  #--------------------------------------------------------------------------
  def self.find_window
    game_name = "\0" * 256
    GetPrivateProfileStringA.call('Game', 'Title', '', game_name, 255, ".\\Game.ini")
    game_name.delete!("\0")
    FindWindowA.call('RGSS Player', game_name)
  end
  #--------------------------------------------------------------------------
  # * Verifica se clicou uma vez
  #     buttons : botões
  #--------------------------------------------------------------------------
  def self.click?(buttons)
    if buttons.is_a?(Array)
      buttons.any? { |button| click?(button) }
    else
      @clicked.include?(KEYS[buttons])
    end
  end
  #--------------------------------------------------------------------------
  # * Verifica se os botões estão sendo pressionandos
  #     buttons : botões
  #--------------------------------------------------------------------------
  def self.press?(buttons)
    if buttons.is_a?(Array)
      buttons.any? { |button| press?(button) }
    else
      @pressed.include?(KEYS[buttons])
    end
  end
  #--------------------------------------------------------------------------
  # * Verifica se clicou duas vezes
  #     buttons : botões
  #--------------------------------------------------------------------------
  def self.double_click?(buttons)
    if buttons.is_a?(Array)
      buttons.any? { |button| double_click?(button) }
    else
      @dbl_clicked.include?(KEYS[buttons])
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização do frame
  #--------------------------------------------------------------------------
  def self.update
    @x, @y = *cursor_pos
    @cursor_sprite.x = @x
    @cursor_sprite.y = @y
    update_states
  end
  #--------------------------------------------------------------------------
  # * Atualização do estado dos botões
  #--------------------------------------------------------------------------
  def self.update_states
    @clicked.clear
    @pressed.clear
    @dbl_clicked.clear
    # Checa apenas uma vez a cada frame se o botão
    #foi ou está sendo pressionado
    KEYS.each_value do |button|
      clicked = (GetAsyncKeyState.call(button) & 0x01 == 1)
      @clicked << button if clicked
      @pressed << button if GetKeyState.call(button) > 1
      if clicked && @states[button] > 0
        @states[button] = 0
        @dbl_clicked << button
      elsif clicked
        @states[button] = 1
      else
        @states[button] = @states.has_key?(button) && @states[button] > 0 && @states[button] < 17 ? @states[button] + 1 : 0
      end
    end
  end
  # Mantém a posição do mouse atualizada, inclusive
  #quando o F2 for pressionado
  HWND = self.find_window
end

#==============================================================================
# ** Sprite_Cursor
#==============================================================================
class Sprite_Cursor < Sprite
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super
    self.bitmap = Bitmap.new(24, 24)
    self.opacity = Mouse_Configs::CURSOR_OPACITY
    self.z = 999
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    bitmap = Cache.system('Iconset')
    rect = Rect.new(Mouse_Configs::CURSOR_ICON % 16 * 24, Mouse_Configs::CURSOR_ICON / 16 * 24, 24, 24)
    self.bitmap.blt(0, 0, bitmap, rect)
  end
end

#==============================================================================
# ** Input
#==============================================================================
class << Input
  #--------------------------------------------------------------------------
  alias dmouse_update update
  #--------------------------------------------------------------------------
  # * Atualização do frame
  #--------------------------------------------------------------------------
  def update
    dmouse_update
    Mouse.update
  end
end

#==============================================================================
# ** DataManager
#==============================================================================
class << DataManager
  #--------------------------------------------------------------------------
  alias dmouse_init init
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def init
    # Inicializa o mouse quando iniciar o projeto e
    #toda vez que o F12 for pressionado
    Mouse.init
    dmouse_init
  end
end
