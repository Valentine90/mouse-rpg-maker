#==============================================================================
# ** Mouse Diamond
#------------------------------------------------------------------------------
# Autor: Valentine
#------------------------------------------------------------------------------
# Versão: 1.5
#==============================================================================

module Mouse_Configs
  # Índice no IconSet.png do ícone do cursor do mouse
  CURSOR_ICON = 147
  
  # Opacidade do cursor (de 0 a 255)
  CURSOR_OPACITY = 255
end

#==============================================================================
# ** Mouse
#==============================================================================
module Mouse
  # Esconde o ícone original do cursor
  Win32API.new('user32', 'ShowCursor', 'I', 'I').call(0)
  # Win32 API
  ScreenToClient = Win32API.new('user32', 'ScreenToClient', 'LP', 'I')
  GetCursorPos = Win32API.new('user32', 'GetCursorPos', 'P', 'I')
  GetPrivateProfileStringA = Win32API.new('kernel32', 'GetPrivateProfileStringA', 'PPPPLP', 'L')
  FindWindowA = Win32API.new('user32', 'FindWindowA', 'PP', 'L')
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
  def self.get_cursor_pos
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
  # * Atualização do frame
  #--------------------------------------------------------------------------
  def self.update
    @x, @y = *get_cursor_pos
    @cursor_sprite.x = @x
    @cursor_sprite.y = @y
  end
  # Mantém a posição do mouse atualizada, inclusive
  #quando pressionar F2
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
    create_bitmap
  end
  #--------------------------------------------------------------------------
  # * Obtenção da posição do cursor
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Bitmap.new(24, 24)
    bitmap = Cache.system('Iconset')
    rect = Rect.new(Mouse_Configs::CURSOR_ICON % 16 * 24, Mouse_Configs::CURSOR_ICON / 16 * 24, 24, 24)
    self.bitmap.blt(0, 0, bitmap, rect)
    self.opacity = Mouse_Configs::CURSOR_OPACITY
    self.z = 999
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
    #toda vez que pressionar F12
    Mouse.init
    dmouse_init
  end
end
