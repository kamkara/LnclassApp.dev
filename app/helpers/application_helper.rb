module ApplicationHelper

    #Onglet Title
    def title
        base_title = "Lnclass Education"
        if @title.nil?
        base_title
        else
        "#{@title} | #{base_title}"
        end
    end
    #site description
    def description
        "Lnclass Education aide les élèves à obtenir le BAC"
    end
end
