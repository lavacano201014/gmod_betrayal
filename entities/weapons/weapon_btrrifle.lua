SWEP.PrintName		= "Shock Rifle"
SWEP.Author		= "Nicholas \"Lavacano\" O'Connor"
SWEP.Instructions	= "Primary fire for normal kill, secondary fire for betrayal."

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight		= 17
SWEP.AutoSwitchTo	= true
SWEP.AutoSwitchFrom	= false

SWEP.Slot		= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true

SWEP.ViewModel		= "models/weapons/v_irifle.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"

local fire_noise = Sound("Metal.SawbladeStick")

function SWEP:PrimaryAttack()
	self:EmitSound(fire_noise)
end

function SWEP:SecondaryAttack()
	self:EmitSound(fire_noise)
end
