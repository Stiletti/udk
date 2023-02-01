class ThirdPersonPawn extends SimplePawn;

var float CameraOffsetDistance;
var float CameraHeight;

simulated function FaceRotation(rotator NewRotation,float DeltaTime)
{
    // if we are moving...
    if(Normal(Acceleration)!=vect(0,0,0))
    {
        NewRotation=rotator((Normal(Acceleration)));
        NewRotation.Pitch=0;

        // ... move camera to our new rotation
        NewRotation=RLerp(Rotation, NewRotation,0.1,true);
        SetRotation(NewRotation);
    }
}

simulated function bool CalcCamera( float fDeltaTime,out vector out_CamLoc,
                                    out rotator out_CamRot,out float out_FOV )
{
    local vector HitNorm,HitLoc,Start,End,vCameraHeight;

    vCameraHeight=vect(0,0,0);
    vCameraHeight.Z=CameraHeight;

    Start=Location;

    End=(Location+vCameraHeight)-(Vector(Controller.Rotation)*CameraOffsetDistance);
    out_CamLoc=End;

    if(Trace(HitLoc,HitNorm,End,Start,false,vect(16,16,16))!=None)
    {
        out_CamLoc=HitLoc+vCameraHeight;
    }

    out_CamRot=rotator((Location+vCameraHeight)-out_CamLoc);
    return true;
}

defaultproperties
{
    CameraHeight=64;
    CameraOffsetDistance=256;

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLight
        bSynthesizeSHLight=TRUE;
    End Object
    Components.Add(MyLight);

    Begin Object Class=SkeletalMeshComponent Name=InitSkeletalMesh
        CastShadow=true;
        bCastDynamicShadow=true;
        bOwnerNoSee=false;
        LightEnvironment=MyLight
        Animations=None;
        SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA';
        AnimSets.Add(AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale');
        PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics';
        AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human';
    End Object
    Mesh=InitSkeletalMesh;
    Components.Add(InitSkeletalMesh);
}