Scriptname PantellaSexLabListenerScript extends ReferenceAlias

MantellaRepository property repository auto
SexLabFramework SexLab
sslUtility Property sslU auto
sslThreadSlots Property Slots auto
sslActorStats Property Stats auto

function Initialize()
    UnregisterForModEvent("SexLabGameLoaded")
    UnregisterForModEvent("HookOrgasmStart")
    UnregisterForModEvent("HookAnimationStart")
	UnregisterForModEvent("HookAnimationEnd")
	UnregisterForModEvent("PantellaBehaviorCall")

    RegisterForModEvent("SexLabGameLoaded","OnSexLabGameLoaded")
    RegisterForModEvent("HookOrgasmStart", "OnSexLabOrgasmStart")
    RegisterForModEvent("HookAnimationStart", "OnAnimationStart")
	RegisterForModEvent("HookAnimationEnd", "AnimationEnd")
	RegisterForModEvent("PantellaBehaviorCall", "OnPantellaBehaviorCalled")

    SexLab = Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework
    SexLabUtil.PrintConsole("Pantella SexLab has initialized and registered for SexLab events. Ready to detect SexLab events.")
endFunction

event OnInit()
    Initialize()
endEvent

Event OnPlayerLoadGame()
    Initialize()
EndEvent

Event OnSexLabGameLoaded()
    Debug.Notification("Pantella SexLab has detected SexLab is installed!")
EndEvent

Event OnSexLabOrgasmStart(Form ActorRef, int FullEnjoyment, int Orgasms)
    SexLabUtil.PrintConsole("Pantella SexLab has detected that a SexLab Orgasm!")
    Actor actor_ref = ActorRef as Actor
    string orgasm_message = "sexlab<Orgasm>actor=" + actor_ref.GetActorBase().GetName() + "|full_enjoyment=" + FullEnjoyment + "|orgasms=" + Orgasms + "\n"
    MiscUtil.WriteToFile("_pantella_in_game_events.txt", orgasm_message)
EndEvent

Event OnAnimationStart(int tid, bool HasPlayer)
    SexLabUtil.PrintConsole("Pantella SexLab has detected that a SexLab animation has started! Thread ID: " + tid + " HasPlayer: " + HasPlayer)
    
    sslThreadController controller = SexLab.GetController(tid as int)
    Actor[] actors_in_animation = Controller.Positions
    Actor player = Game.GetPlayer()
    string animation_start_message = "sexlab<AnimationStart>animation_name=" + controller.Animation.Name
    animation_start_message += "|actors="
    int j = actors_in_animation.Length
    while j > 0
        j -= 1
        string actorName = actors_in_animation[j].GetActorBase().GetName()
        if actors_in_animation[j] == player
            actorName = "[player]"
        endif
        SexLabUtil.PrintConsole("Pantella SexLab detected actor: " + actorName)
        animation_start_message += actorName
        if j > 0
            animation_start_message += ","
        endif
    endwhile
    animation_start_message += "|tags="
    string[] tags = controller.Animation.GetRawTags()
    int i = tags.Length
    while i > 0
        i -= 1
        animation_start_message += tags[i]
        if i > 0
            animation_start_message += ","
        endif
    endwhile
    animation_start_message += "\n"
    MiscUtil.WriteToFile("_pantella_in_game_events.txt", animation_start_message)
EndEvent

event AnimationEnd(int ThreadID, bool HasPlayer)
    SexLabUtil.PrintConsole("Pantella SexLab has detected that a SexLab animation has ended!")
    sslThreadController controller = SexLab.GetController(ThreadID)
    Actor[] actors_in_animation = Controller.Positions
    Actor player = Game.GetPlayer()
    string animation_end_message = "sexlab<AnimationEnd>animation_name=" + controller.Animation.Name
    animation_end_message += "|actors="
    int j = actors_in_animation.Length
    while j > 0
        j -= 1
        string actorName = actors_in_animation[j].GetActorBase().GetName()
        if actors_in_animation[j] == player
            actorName = "[player]"
        endif
        SexLabUtil.PrintConsole("Pantella SexLab detected actor: " + actorName)
        animation_end_message += actorName
        if j > 0
            animation_end_message += ","
        endif
    endwhile
    animation_end_message += "\n"
    MiscUtil.WriteToFile("_pantella_in_game_events.txt", animation_end_message)
endEvent

Event OnPantellaBehaviorCalled(Form caster, Form target, String methodName, String argsString)
    SexLabUtil.PrintConsole("Pantella SexLab has detected a PantellaBehaviorCall event! methodName: " + methodName + " argsString: " + argsString)
    String[] args = PapyrusUtil.StringSplit(argsString, "<>")
    Actor caster_actor = caster as Actor
    Actor target_actor = target as actor
    String casterName = caster_actor.getdisplayname()
    String targetName = target_actor.getdisplayname()
    if (casterName == targetName) ; TODO: only handles case when conversation includes 2 actors with the same name. Would like to handle case when an arbitrary number of actors with the same name are in the conversation
        casterName = casterName + " 1"
        targetName = targetName + " 2"
    endIf
    if methodName == "SexLabHaveSex"
        Debug.Notification(casterName + " is starting to have sex with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        Thread.SetHook("PantellaSexLabHaveSexBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabHaveOralSex"
        Debug.Notification(casterName + " is starting to have oral sex with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(2, "Oral")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHaveOralSexBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabHaveHandjobSex"
        Debug.Notification(casterName + " is handjobbing with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(2, "Handjob")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHaveHandjobSexBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabHaveVaginalSex"
        Debug.Notification(casterName + " is starting to have vaginal sex with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(2, "Vaginal")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHaveVaginalSexBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabHaveAnalSex"
        Debug.Notification(casterName + " is starting to have anal sex with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(2, "Anal")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHaveAnalSexBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabHave69Sex"
        Debug.Notification(casterName + " is starting to 69 with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(2, "69")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHave69SexBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabHFisting"
        Debug.Notification(casterName + " has started fisting with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(2, "Fisting")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHFistingBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabHaveBlowjob"
        Debug.Notification(casterName + " is starting to blowjob with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(caster_actor)
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(2, "Blowjob")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHaveBlowjobBehavior")
        Thread.StartThread()
    elseif methodName == "SexLabMasturbate"
        Debug.Notification(casterName + " is starting to blowjob with " + targetName)
        sslThreadModel Thread = SexLab.NewThread()
        Thread.AddActor(target_actor, true)
        sslBaseAnimation[] anims = SexLab.GetAnimationsbyTag(1, "Masturbate")
        Thread.SetAnimations(anims)
        Thread.SetHook("PantellaSexLabHaveBlowjobBehavior")
        Thread.StartThread()
    endif
EndEvent